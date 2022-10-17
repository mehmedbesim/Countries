import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryFavourite: UIButton!
    
    var country: Country?
    private var isFavourite: Bool = false
    var savedListChangeListener: OnSavedListChange?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupViews() {
        container.layer.borderColor = UIColor.systemGray4.cgColor
        container.layer.borderWidth = 2
        container.layer.cornerRadius = 20
        
        container.layer.shadowColor = UIColor.gray.cgColor
        container.layer.shadowOpacity = 0.3
        container.layer.shadowOffset = CGSize.zero
        container.layer.shadowRadius = 6
        
        if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
            let saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
            setFavourite(isFavourite: saved.contains(self.country!))
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
        savedListChangeListener?.savedListChanged()
    }
    
    private func removeFavourite() {
        if let data = UserDefaults.standard.value(forKey:"saved") as? Data {
            var saved = try! PropertyListDecoder().decode(Array<Country>.self, from: data)
            if let index = saved.firstIndex(of: country!) {
                saved.remove(at: index)
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(saved), forKey:"saved")
            setFavourite(isFavourite: false)
            savedListChangeListener?.savedListChanged()
        }
    }
    
    private func setFavourite(isFavourite: Bool) {
        self.isFavourite = isFavourite
        if isFavourite {
            countryFavourite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            countryFavourite.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    @IBAction func onFavClicked(_ sender: UIButton) {
        if !isFavourite {
            addFavourite()
        } else {
            removeFavourite()
        }
    }
}

protocol OnSavedListChange {
    func savedListChanged()
}
