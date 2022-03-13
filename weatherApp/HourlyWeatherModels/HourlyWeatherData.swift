import Foundation

class HourlyWeatherDescription: Decodable {
    var dt: Int?
    var temp: Double?
    var weather: [HourlyWeatherImageDescription]?
}
