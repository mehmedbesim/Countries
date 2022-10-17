import UIKit
import Kingfisher
import SafariServices
import Alamofire
import SVGKit

class DetailVC: UIViewController {
    
    @IBOutlet weak var flagIV: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var favouriteBarItem: UIBarButtonItem!
    
    let detailUrl = "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/"
    let AUTH_HEADERS: HTTPHeaders = [
        "x-rapidapi-key": "b6b096306cmsh523c1dcc7295874p10f038jsnd0911eecbf30"
    ]
    
    var country: Country?
    private var isFavourite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let c = country {
            getCountryDetail(code: c.code)
            navigationItem.title = c.name
            countryCodeLabel.attributedText = NSMutableAttributedString()
                .bold("Country Code: ")
                .normal(c.code)
            if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
                let saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
                setFavourite(isFavourite: saved.contains(c))
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setTabBarHidden(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        setTabBarHidden(false)
    }
    
    func getCountryDetail(code: String){
        AF.request(self.detailUrl + code, method: .get, headers: AUTH_HEADERS).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("API Response: \(value)")
                do {
                    let res = try JSONDecoder().decode(CountryDetailResponse.self, from: response.data!)
                    self.loadFlag(url: res.data.flagImageUri)
                } catch {
                    let message: String = (value as? NSDictionary)?.value(forKey: "message") as? String ?? "Response JSON Hatası"
                    let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { (action: UIAlertAction!) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadFlag(url: String) {
        if let url = URL(string: url) {
            DispatchQueue.main.async {
                self.flagIV.kf.setImage(with: url, options: [.processor(SVGImgProcessor())])
            }
        }
    }
    
    @IBAction func onClickMoreInformation(_ sender: UIButton) {
        guard let wikiId = country?.wikiDataId else {
            return
        }
        
        if let url = URL(string: "https://www.wikidata.org/wiki/" + wikiId) {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func onFavClicked(_ sender: UIBarButtonItem) {
        if !isFavourite {
            addFavourite()
        } else {
            removeFavourite()
        }
    }
    
    private func setFavourite(isFavourite: Bool) {
        self.isFavourite = isFavourite
        if isFavourite {
            favouriteBarItem.image = UIImage(systemName: "star.fill")
        } else {
            favouriteBarItem.image = UIImage(systemName: "star")
        }
    }
    
    private func addFavourite() {
        if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
            var saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
            saved.append(self.country!)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(saved), forKey:"saved")
        } else {
            var saved = [Country]()
            saved.append(self.country!)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(saved), forKey:"saved")
        }
        setFavourite(isFavourite: true)
    }
    
    private func removeFavourite() {
        if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
            var saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
            if let index = saved.firstIndex(of: country!) {
                saved.remove(at: index)
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(saved), forKey:"saved")
            setFavourite(isFavourite: false)
        }
    }
}
