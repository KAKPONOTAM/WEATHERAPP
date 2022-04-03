import UIKit
class WeatherDataViewController: UIViewController {
    //MARK: - properties
    private var currentWeatherData: CurrentWeatherInfo?
    private var filteredArray = [String]()
    private var weeklyWeatherData: WeeklyWeatherData?
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "backgroundImage")
        return imageView
    }()
    
    private let weatherInfoTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = LayerManager.shared.cornerRadius
        button.addTarget(self, action: #selector(presentCityNames), for: .touchUpInside)
        return button
    }()
    
    init(cityName: String, currentWeatherInfo: CurrentWeatherInfo?, weeklyWeatherInfo: WeeklyWeatherData?) {
        self.currentWeatherData = currentWeatherInfo
        self.weeklyWeatherData = weeklyWeatherInfo
        cityNameLabel.text = cityName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        setupConstraints()
        setupTableView()
    }
    
    private func setupTableView() {
        weatherInfoTableView.delegate = self
        weatherInfoTableView.dataSource = self
        
        weatherInfoTableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: CurrentWeatherTableViewCell.identifier)
        weatherInfoTableView.register(WeekWeatherInfoTableViewCell.self, forCellReuseIdentifier: WeekWeatherInfoTableViewCell.identifier)
        weatherInfoTableView.register(HourlyWeatherDataTableViewCell.self, forCellReuseIdentifier: HourlyWeatherDataTableViewCell.identifier)
        weatherInfoTableView.register(SunriseAndSunsetTableViewCell.self, forCellReuseIdentifier: SunriseAndSunsetTableViewCell.identifier)
    }
    
    private func addSubview() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(weatherInfoTableView)
        backgroundImageView.addSubview(exitButton)
        backgroundImageView.addSubview(cityNameLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherInfoTableView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 100),
            weatherInfoTableView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            weatherInfoTableView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            weatherInfoTableView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            exitButton.bottomAnchor.constraint(equalTo: weatherInfoTableView.topAnchor, constant: -10),
            exitButton.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor, constant: 20),
            exitButton.widthAnchor.constraint(equalToConstant: 50),
            exitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            cityNameLabel.bottomAnchor.constraint(equalTo: weatherInfoTableView.topAnchor),
            cityNameLabel.leadingAnchor.constraint(equalTo: exitButton.trailingAnchor),
            cityNameLabel.trailingAnchor.constraint(equalTo: weatherInfoTableView.trailingAnchor, constant: -50),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func presentCityNames() {
        let citiesViewController = CitiesViewController()
        citiesViewController.delegate = self
        present(citiesViewController, animated: true, completion: nil)
    }
}

extension WeatherDataViewController: UITableViewDataSource, UITableViewDelegate, CitiesViewControllerDelegate {
    func fetchWeatherRequest(cityName: String) {
        WeatherNetworkManager.shared.fetchRequestDataForCurrentWeather(cityName: cityName) { [weak self] currentWeatherInfo in
            guard let currentWeatherInfo = currentWeatherInfo else { return }
            self?.currentWeatherData = currentWeatherInfo
            self?.cityNameLabel.text = cityName
            
            guard let lon = self?.currentWeatherData?.coord?.lon,
                  let lat = self?.currentWeatherData?.coord?.lat else { return }
            
            WeatherNetworkManager.shared.fetchRequestDataForWeeklyWeather(lon: lon, lat: lat) { [weak self] weeklyWeatherInfo in
                guard let weeklyWeatherInfo = weeklyWeatherInfo else { return }
                self?.weeklyWeatherData = weeklyWeatherInfo
                
                self?.weatherInfoTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let currentWeatherCell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherTableViewCell.identifier, for: indexPath) as? CurrentWeatherTableViewCell else { return UITableViewCell() }
            
            guard let currentWeatherData = currentWeatherData else { return UITableViewCell() }
            
            currentWeatherCell.currentWeatherTableViewCellConfigure(currentWeatherData: currentWeatherData)
            return currentWeatherCell
            
        case 1:
            guard let hourlyWeatherCell = tableView.dequeueReusableCell(withIdentifier: HourlyWeatherDataTableViewCell.identifier, for: indexPath) as? HourlyWeatherDataTableViewCell else { return UITableViewCell() }
            
            guard let weeklyWeatherData = weeklyWeatherData else { return UITableViewCell() }
            
            hourlyWeatherCell.hourlyWeatherTableViewCellConfigure(hourWeatherData: weeklyWeatherData)
            
            return hourlyWeatherCell
            
        case 2:
            guard let weeklyWeatherCell = tableView.dequeueReusableCell(withIdentifier: WeekWeatherInfoTableViewCell.identifier, for: indexPath) as? WeekWeatherInfoTableViewCell else { return UITableViewCell() }
            
            guard let weeklyWeatherData = weeklyWeatherData else { return UITableViewCell() }
            
            weeklyWeatherCell.weeklyWeatherTableViewCellConfigure(weeklyWeatherData: weeklyWeatherData, indexPath: indexPath)
            return weeklyWeatherCell
            
        case 3:
            guard let sunriseAndSunsetInfoCell = tableView.dequeueReusableCell(withIdentifier: SunriseAndSunsetTableViewCell.identifier, for: indexPath) as? SunriseAndSunsetTableViewCell else { return UITableViewCell() }
            
            guard let currentWeatherData = currentWeatherData else { return UITableViewCell() }
            
            sunriseAndSunsetInfoCell.configure(sunriseAndSunsetTime: currentWeatherData)
            return sunriseAndSunsetInfoCell
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
            
        case 1:
            return 1
            
        case 2:
            return weeklyWeatherData?.daily?.count ?? 0
            
        case 3:
            return 1
            
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let headLabel = UILabel(frame: CGRect(x: 5, y: 0, width: headerView.frame.width , height: 50))
        headLabel.textAlignment = .left
        headLabel.textColor = .white
        
        switch section {
        case 0:
            headLabel.text = "current weather info"
            
        case 1:
            headLabel.text = "hourly weather info"
            
        case 2:
            headLabel.text = "weekly weather info"
            
        case 3:
            headLabel.text = "sunrise and sunset time"
        default:
            break
        }
        
        headerView.addSubview(headLabel)
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 150
            
        case 1:
            return 150
            
        case 2:
            return 100
            
        case 3:
            return 150
            
        default:
            break
        }
        
        return 0
    }
}
