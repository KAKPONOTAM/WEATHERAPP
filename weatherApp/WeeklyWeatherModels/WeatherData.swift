import Foundation

class WeeklyWeatherData: Decodable {
    var timezone_offset: Int?
    var daily: [WeeklyWeatherTemperatureTypes]?
    var wind_speed: Double?
    var hourly: [HourlyWeatherDescription]?
}
