import UIKit
import Alamofire

class HomeVC: UIViewController {
    
    let BASE_URL: String = "https://wft-geo-db.p.rapidapi.com"
    let firstPath: String = "/v1/geo/countries?limit=10"
    
    var isDataLoading = false
    
    let AUTH_HEADERS: HTTPHeaders = [
        "x-rapidapi-key": "1ddee3756fmsh1af6af66c3049a6p18d606jsn0c6dfa3361af"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCountries(path: firstPath)
    }
    
    func getCountries(path: String){
        if isDataLoading {
            return
        }
        isDataLoading = true
        
        AF.request(self.BASE_URL + path, method: .get, headers: AUTH_HEADERS).responseJSON { response in
            switch response.result {
            case .success(let value):
                self.isDataLoading = false
                do {
                    let res = try JSONDecoder().decode(CountriesResponse.self, from: response.data!)
                    if path == self.firstPath {
                        self.countries = res.data
                    } else {
                        self.countries.append(contentsOf: res.data)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print("API Response: \(value)")
                    let message: String = (value as? NSDictionary)?.value(forKey: "message") as? String ?? "Response JSON Error"
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            case .failure(let error):
                self.isDataLoading = false
                print(error)
            }

        }
    }
    
}

extension HomeVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = countries[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryTableViewCell
        
        cell.country = country
        cell.setupViews()
        cell.selectionStyle = .none
        cell.countryName.text = country.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        performSegue(withIdentifier: "countriesToDetail", sender: country)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countriesToDetail" {
            let country = sender as? Country
            let targetVC = segue.destination as! DetailVC
            targetVC.country = country
        }
    }
}
