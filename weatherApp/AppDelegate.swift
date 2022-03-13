import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoadWeatherDataViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
}

/*
 switch locationManager.authorizationStatus {
 case .authorizedAlways, .authorizedWhenInUse, .restricted, .notDetermined, .denied:
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
 */
