import Foundation

class CurrentWeatherInfo: Decodable {
    var weather: [Weather]?
    var main: Main?
    var wind: Wind?
    var name: String?
    var coord: CurrentWeatherCoordinates?
    var sys: SunriseAndSunsetTime?
}
