import UIKit
import CoreLocation

class LoadWeatherDataViewController: UIViewController {
    //MARK: - properties
    private let locationManager = CLLocationManager()
    private var currentWeatherData = CurrentWeatherInfo()
    private var weeklyWeatherData = WeeklyWeatherData()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let greetingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "greetingImage")
        imageView.startAnimating()
        return imageView
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(greetingImageView)
        setupConstraints()
        showActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkGeoDataEnabled()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            greetingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            greetingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            greetingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            greetingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - methods
    func showActivityIndicator() {
        activityIndicator.color = .white
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    private func geolocationRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func checkGeoDataEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            geolocationRequest()
            checkAuthorization()
        } else {
            let alert = UIAlertController(title: "Your location isn't enabled", message: "do you want to enable it?", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                guard let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            WeatherNetworkManager.shared.fetchRequestDataForCurrentWeather(cityName: "Москва") { [weak self] currentWeatherInfo in
                guard let currentWeatherInfo = currentWeatherInfo else { return }
                self?.currentWeatherData = currentWeatherInfo
                
                guard let lon = self?.currentWeatherData.coord?.lon,
                      let lat = self?.currentWeatherData.coord?.lat,
                      let cityName = self?.currentWeatherData.name else { return }
                
                WeatherNetworkManager.shared.fetchRequestDataForWeeklyWeather(lon: lon, lat: lat) { [weak self] weeklyWeatherInfo in
                    guard let weeklyWeatherInfo = weeklyWeatherInfo else { return }
                    self?.weeklyWeatherData = weeklyWeatherInfo
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let weatherVC = WeatherDataViewController(cityName: cityName, currentWeatherInfo: self?.currentWeatherData, weeklyWeatherInfo: self?.weeklyWeatherData)
                        weatherVC.modalPresentationStyle = .overFullScreen
                        self?.present(weatherVC, animated: true, completion: nil)
                    }
                }
            }
            
        case .authorizedAlways, .authorizedWhenInUse:
            guard let lon = locationManager.location?.coordinate.longitude,
                  let lat = locationManager.location?.coordinate.latitude else { return }
            
            WeatherNetworkManager.shared.fetchRequestDataForWeatherWhenUserFirstOpenedApp(lon: lon, lat: lat) { [weak self] currentWeatherInfo in
                guard let currentWeatherInfo = currentWeatherInfo else { return }
                self?.currentWeatherData = currentWeatherInfo
                guard let cityName = self?.currentWeatherData.name else { return }
                
                WeatherNetworkManager.shared.fetchRequestDataForWeeklyWeather(lon: lon, lat: lat) { [weak self] weeklyWeatherInfo in
                    guard let weeklyWeatherInfo = weeklyWeatherInfo else { return }
                    self?.weeklyWeatherData = weeklyWeatherInfo
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let weatherVC = WeatherDataViewController(cityName: cityName, currentWeatherInfo: self?.currentWeatherData, weeklyWeatherInfo: self?.weeklyWeatherData)
                        weatherVC.modalPresentationStyle = .overFullScreen
                        self?.present(weatherVC, animated: true, completion: nil)
                    }
                }
            }
            
        @unknown default:
            break
        }
    }
}

extension LoadWeatherDataViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
