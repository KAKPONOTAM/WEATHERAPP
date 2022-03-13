import Foundation

class WeeklyWeatherTemperatureTypes: Decodable {
    var dt: Int?
    var temp: Temperature?
    var feels_like: TemperatureFeelsLike?
    var weather: [WeeklyWeatherDescriptionIcon]?
}
