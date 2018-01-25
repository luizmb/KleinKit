import Foundation

extension Date {
    public init?(day: Int, month: Int, year: Int,
                 hour: Int?, minute: Int?, second: Int?,
                 timeZone: TimeZone = TimeZone(abbreviation: "UTC")!) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.timeZone = timeZone
        guard let date = Calendar.current.date(from: components) else { return nil }
        self = date
    }

    public static var now: Date {
        // Always use Date.now instead of Date()
        // Then if you wanna mock a date, should
        // be easy to override this implementation
        return getNow()
    }

    #if TEST
    public static var getNow: () -> Date = { Date() }
    #else
    private static var getNow: () -> Date = { Date() }
    #endif

    public func formattedFromComponents(styleAttitude: DateFormatter.Style, year: Bool = false, month: Bool = false, day: Bool = false, hour: Bool = false, minute: Bool = false, second: Bool = false, locale: Locale = Locale.current) -> String {
        let long = styleAttitude == .long || styleAttitude == .full
        let short = styleAttitude == .short
        var comps = ""

        if year { comps += long ? "yyyy" : "yy" }
        if month { comps += long ? "MMMM" : (short ? "MM" : "MMM") }
        if day { comps += long ? "dd" : "d" }

        if hour { comps += long ? "HH" : "H" }
        if minute { comps += long ? "mm" : "m" }
        if second { comps += long ? "ss" : "s" }
        let format = DateFormatter.dateFormat(fromTemplate: comps, options: 00, locale: locale)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    public var backToMidnight: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    public func addingDays(_ days: Int) -> Date {
        let calendar = Calendar.current
        var daysOffset = DateComponents()
        daysOffset.day = days
        return calendar.date(byAdding: daysOffset, to: self)!
    }

    public func addingHours(_ hours: Int) -> Date {
        let calendar = Calendar.current
        var hoursOffset = DateComponents()
        hoursOffset.hour = hours
        return calendar.date(byAdding: hoursOffset, to: self)!
    }

    public func addingMinutes(_ minutes: Int) -> Date {
        let calendar = Calendar.current
        var minutesOffset = DateComponents()
        minutesOffset.minute = minutes
        return calendar.date(byAdding: minutesOffset, to: self)!
    }

    public static var yesterday: Date {
        return Date.yesterdayThisTime.backToMidnight
    }

    public static var yesterdayThisTime: Date {
        return Date.now.addingDays(-1)
    }

    public var nextDay: Date {
        return self.backToMidnight.addingDays(1)
    }

    public static var today: Date {
        return Date.now.backToMidnight
    }

    public static var tomorrow: Date {
        return Date.tomorrowThisTime.backToMidnight
    }

    public static var tomorrowThisTime: Date {
        return Date.now.addingDays(1)
    }

    public func at(hour: Int) -> Date {
        return self.backToMidnight.addingHours(hour)
    }

    public var morning: Date {
        return self.at(hour: 6)
    }

    public var lunch: Date {
        return self.at(hour: 12)
    }

    public var evening: Date {
        return self.at(hour: 18)
    }

}

extension Date {
    // Comparison
    public enum DateComparisonResult: Int {
        case past = -1
        case identical = 0
        case future = 1
    }

    public func whenCompared(to other: Date) -> DateComparisonResult {
        return DateComparisonResult(rawValue: self.compare(other).rawValue)!
    }

    public func whenComparedIgnoringTime(to other: Date) -> DateComparisonResult {
        return DateComparisonResult(rawValue: self.backToMidnight.compare(other.backToMidnight).rawValue)!
    }

    public func whenTimeComparedIgnoringDate(to other: Date) -> DateComparisonResult {
        return self.whenTimeComparedIgnoringDate(in: .current, to: other, in: .current)
    }

    public func whenTimeComparedIgnoringDate(in timezone: TimeZone, to other: Date, in timezoneOther: TimeZone) -> DateComparisonResult {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let selfComponents = calendar.dateComponents(in: timezone, from: self)
        let selfTime = formatter.date(from: "1970-01-01 \(selfComponents.hour!):\(selfComponents.minute!):\(selfComponents.second!)")!

        let otherComponents = calendar.dateComponents(in: timezoneOther, from: other)
        let otherTime = formatter.date(from: "1970-01-01 \(otherComponents.hour!):\(otherComponents.minute!):\(otherComponents.second!)")!

        return DateComparisonResult(rawValue: selfTime.compare(otherTime).rawValue)!
    }
}
