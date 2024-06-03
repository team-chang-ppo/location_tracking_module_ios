import Foundation

struct Utils {
    
    public static func utcToLocale(utcDate: String, dateFormat: String) -> String {
        let dfFormat = DateFormatter()
        dfFormat.dateFormat = dateFormat
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        guard let dtUtcDate = dfFormat.date(from: utcDate) else { return utcDate }
        
        dfFormat.timeZone = TimeZone.current
        dfFormat.dateFormat = dateFormat
        return dfFormat.string(from: dtUtcDate)
    }
    
    public static func localeToUtc(localeDate: String, dateFormat: String) -> String {
        let dfFormat = DateFormatter()
        dfFormat.dateFormat = dateFormat
        dfFormat.timeZone = TimeZone.current
        guard let dtLocaleDate = dfFormat.date(from: localeDate) else { return localeDate }
        
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        dfFormat.dateFormat = dateFormat
        return dfFormat.string(from: dtLocaleDate)
    }
    
    public static func addHoursToDate(date: String, dateFormat: String, hours: Int) -> String {
        let dfFormat = DateFormatter()
        dfFormat.dateFormat = dateFormat
        dfFormat.timeZone = TimeZone(abbreviation: "UTC")
        guard let dtDate = dfFormat.date(from: date) else { return date }
        
        let newDate = Calendar.current.date(byAdding: .hour, value: hours, to: dtDate)!
        
        dfFormat.timeZone = TimeZone.current
        return dfFormat.string(from: newDate)
    }
}
