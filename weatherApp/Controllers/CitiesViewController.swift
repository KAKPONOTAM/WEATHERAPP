import Foundation
import UIKit
import CoreLocation

protocol CitiesViewControllerDelegate: AnyObject {
    func fetchWeatherRequest(cityName: String)
}

class CitiesViewController: UIViewController {
    //MARK: - properties
    private let searchTableView = UITableView()
    private var citiesInfo = CityNamesData()
    private var citiesArray = [CityNames]()
    private var currentWeatherData: CurrentWeatherInfo?
    private var weeklyWeatherData: WeeklyWeatherData?
    private let locationManager = CLLocationManager()
    private var filteredCityNamesArray = [String]()
    private var cityNamesArray = [String]()
    weak var delegate: CitiesViewControllerDelegate?
    
    private let searchTextField: UISearchTextField = {
        let textField = UISearchTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "search"
        textField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        return textField
    }()
  
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableViewSetup()
        addSubview()
        setupConstraints()
        cityNamesArraySetup()
    }
    
    //MARK: - methods
    private func cityNamesArraySetup() {
        CitiesJSONAutoParts.shared.citiesJSONAutoParts { cityInfo in
            guard let cityInfo = cityInfo,
                  let citiesArray = cityInfo.city else { return }
            self.citiesInfo = cityInfo
            self.citiesArray = citiesArray
        }
        
        for word in citiesArray {
            guard let cityName = word.name else { return }
            cityNamesArray.append(cityName)
        }
        
        filteredCityNamesArray = cityNamesArray
    }
    
    private func tableViewSetup() {
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(CityNameTableViewCell.self, forCellReuseIdentifier: CityNameTableViewCell.identifier)
    }
    
    private func addSubview() {
        view.addSubview(searchTableView)
        view.addSubview(searchTextField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            searchTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchTextField.bottomAnchor.constraint(equalTo: searchTableView.topAnchor, constant: -10)
        ])
    }
    
    @objc func searchTextChanged() {
        guard let searchTextFieldText = searchTextField.text else { return }
        
        switch searchTextFieldText.isEmpty {
        case true:
            filteredCityNamesArray = cityNamesArray
            
        case false:
            filteredCityNamesArray = cityNamesArray.filter { $0.lowercased().contains(searchTextFieldText.lowercased()) }
        }
        
        searchTableView.reloadData()
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCityNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityNameTableViewCell.identifier, for: indexPath) as? CityNameTableViewCell else { return UITableViewCell() }
        
        cell.cityTableViewCellConfigure(cityName: filteredCityNamesArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.fetchWeatherRequest(cityName: filteredCityNamesArray[indexPath.row])
        dismiss(animated: true, completion: nil)
    }
}


