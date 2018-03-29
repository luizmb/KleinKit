import Foundation

public enum AsyncResult<T> {
    case notLoaded
    case loading(task: CancelableTask, oldValue: Result<T>?)
    case loaded(Result<T>)
}

extension AsyncResult: Equatable where T: Equatable { }

public func ==<T> (lhs: AsyncResult<T>, rhs: AsyncResult<T>) -> Bool where T: Equatable {
    switch (lhs, rhs) {
    case (.notLoaded, .notLoaded):
        return true
    case (.loading(_, let lhs), .loading(_, let rhs)):
        return lhs == rhs
    case (.loaded(let lhs), .loaded(let rhs)):
        return lhs == rhs
    default:
        return false
    }
}

extension AsyncResult {
    public func possibleResult() -> Result<T>? {
        switch self {
        case .notLoaded: return nil
        case .loading(_, let oldValue): return oldValue
        case .loaded(let value): return value
        }
    }

    public func possibleValue() -> T? {
        return self.possibleResult().flatMap {
            switch $0 {
            case .success(let value): return value
            default: return nil
            }
        }
    }
}
