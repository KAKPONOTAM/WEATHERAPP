import UIKit

class CityNameTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    
    func cityTableViewCellConfigure(cityName: String) {
        var content = self.defaultContentConfiguration()
        content.text = cityName
        self.contentConfiguration = content
    }
}
