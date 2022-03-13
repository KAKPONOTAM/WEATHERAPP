import Foundation
import UIKit

//MARK: - making custom class
class CitiesJSONAutoParts {
    //MARK: - private init()
    private init() {}
    
    //MARK: - properties
    static let shared = CitiesJSONAutoParts()
    
    
    //MARK: - methods
    func citiesJSONAutoParts(completion: @escaping (CityNamesData?) -> ()) {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let citiesInfo = try JSONDecoder().decode(CityNamesData.self, from: data)
            completion(citiesInfo)
        } catch {
            print(error.localizedDescription)
        }
    }
}

