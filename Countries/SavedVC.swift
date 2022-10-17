import UIKit

class SavedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var countries = [Country]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedList()
    }
    
    private func loadSavedList() {
        if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
            let saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
            countries = saved
            self.tableView.reloadData()
        }
    }
}

extension SavedVC : UITableViewDelegate, UITableViewDataSource, OnSavedListChange {
    
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
        
        cell.savedListChangeListener = self
        
        return cell
    }
    
    func savedListChanged() {
        self.loadSavedList()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[indexPath.row]
        performSegue(withIdentifier: "savedToDetail", sender: country)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "savedToDetail" {
            let country = sender as? Country
            let targetVC = segue.destination as! DetailVC
            targetVC.country = country
        }
    }
}
