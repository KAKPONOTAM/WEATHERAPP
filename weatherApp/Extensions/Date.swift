import Foundation

extension Date {
    static func getCorrectHour(unixTime: Int, timezoneOffset: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        let timezone = TimeZone(secondsFromGMT: timezoneOffset)
        dateFormatter.timeZone = timezone
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }
    
    static func getCorrectDay(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
    
    static func getCorrectTimeForSunriseAndSunset(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
