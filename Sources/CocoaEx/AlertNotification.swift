public struct AlertNotification {
    public enum Level {
        case info, success, warning, error
    }
    let title: String
    let message: String
    let level: Level
}

extension AlertNotification: Equatable {}
public func == (lhs: AlertNotification, rhs: AlertNotification) -> Bool {
    guard lhs.title == rhs.title else { return false }
    guard lhs.message == rhs.message else { return false }
    guard lhs.level == rhs.level else { return false }
    return true
}
