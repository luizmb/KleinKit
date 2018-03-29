import Foundation

public enum Async<T> {
    case notLoaded
    case loading
    case loaded(T)
}

extension Async: Equatable where T: Equatable { }

public func ==<T> (lhs: Async<T>, rhs: Async<T>) -> Bool where T: Equatable {
    switch (lhs, rhs) {
    case (.notLoaded, .notLoaded):
        return true
    case (.loading, .loading):
        return true
    case (.loaded(let lhs), .loaded(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

extension Async {
    public func possibleValue() -> T? {
        switch self {
        case .notLoaded, .loading: return nil
        case .loaded(let value): return value
        }
    }
}
