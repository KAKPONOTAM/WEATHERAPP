import Foundation

//MARK: - making custom class
class WeatherNetworkManager {
    //MARK: - properties
    static let shared = WeatherNetworkManager()
    
    //MARK: - private init
    private init() {}
    
    //MARK: - methods
    func fetchRequestDataForWeatherWhenUserFirstOpenedApp(lon: Double, lat: Double, completion: @escaping (CurrentWeatherInfo?) -> ()) {
        let dataString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=9f9bd273673c133c5d046f2157e4885f"
        guard let url = URL(string: dataString) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil,
               let data = data {
                do {
                    let weatherData = try JSONDecoder().decode(CurrentWeatherInfo.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(weatherData)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
        
    }
    
    func fetchRequestDataForCurrentWeather(cityName: String, completion: @escaping (CurrentWeatherInfo?) -> ()) {
        let dataString = "https://api.openweathermap.org/data/2.5/weather?lat=55.7522&lon=37.6156&q=\(cityName)&units=metric&appid=9f9bd273673c133c5d046f2157e4885f".encodeUrl
        guard let url = URL(string: dataString) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil,
               let data = data {
                do {
                    let currentWeatherData = try JSONDecoder().decode(CurrentWeatherInfo.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(currentWeatherData)
                    }
                    
                } catch {
                    
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    func fetchRequestDataForWeeklyWeather(lon: Double, lat: Double, completion: @escaping (WeeklyWeatherData?) ->()) {
        let dataString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=9f9bd273673c133c5d046f2157e4885f"
        
        guard let url = URL(string: dataString) else { return }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil,
               let data = data {
                do {
                    let weeklyWeatherData = try JSONDecoder().decode(WeeklyWeatherData.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(weeklyWeatherData)
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
}
