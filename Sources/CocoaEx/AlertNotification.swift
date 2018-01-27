public struct AlertNotification {
    public enum Level {
        case info, success, warning, error
    }
    public let title: String
    public let message: String
    public let level: Level

    public init(title: String, message: String, level: Level) {
        self.title = title
        self.message = message
        self.level = level
    }
}

extension AlertNotification: Equatable {}
public func == (lhs: AlertNotification, rhs: AlertNotification) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.message == rhs.message else { return false }
    guard lhs.level == rhs.level else { return false }
    return true
}
