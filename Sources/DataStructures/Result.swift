import Foundation

public enum Result<T> {
    case success(T)
    case failure(Error)
}

// MARK: - Functor, Monad
extension Result {
    @_inlineable
    public func map<B>(_ transform: (T) throws -> B) rethrows -> Result<B> {
        switch self {
        case .success(let valueT): return .success(try transform(valueT))
        case .failure(let error): return .failure(error)
        }
    }

    @_inlineable
    public func flatMap<B>(_ transform: (T) throws -> Result<B>) rethrows -> Result<B> {
        switch self {
        case .success(let valueT): return try transform(valueT)
        case .failure(let error): return .failure(error)
        }
    }
}

// MARK: - Equality for Equatable
@_inlineable
public func == <T: Equatable>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    switch (lhs, rhs) {
    case let (.success(l), .success(r)):
        return l == r
    case let (.failure(l), .failure(r)):
        return l.localizedDescription == r.localizedDescription
    default:
        return false
    }
}

@_inlineable
public func != <T: Equatable>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    return !(lhs == rhs)
}

// MARK: - Equality for Optional
@_inlineable
public func == <T: Equatable>(lhs: Result<Optional<T>>, rhs: Result<Optional<T>>) -> Bool {
    switch (lhs, rhs) {
    case let (.success(l), .success(r)):
        return l == r
    case let (.failure(l), .failure(r)):
        return l.localizedDescription == r.localizedDescription
    default:
        return false
    }
}

@_inlineable
public func != <T: Equatable>(lhs: Result<Optional<T>>, rhs: Result<Optional<T>>) -> Bool {
    return !(lhs == rhs)
}

// MARK: - Equality for Array
@_inlineable
public func == <T: Equatable>(lhs: Result<Array<T>>, rhs: Result<Array<T>>) -> Bool {
    switch (lhs, rhs) {
    case let (.success(l), .success(r)):
        return l == r
    case let (.failure(l), .failure(r)):
        return l.localizedDescription == r.localizedDescription
    default:
        return false
    }
}

@_inlineable
public func != <T: Equatable>(lhs: Result<Array<T>>, rhs: Result<Array<T>>) -> Bool {
    return !(lhs == rhs)
}

// MARK: - Coalescing operator
infix operator ???: NilCoalescingPrecedence

@_transparent
public func ??? <T>(result: Result<T>, defaultValue: @autoclosure () throws -> T)
    rethrows -> T {
        switch result {
        case .success(let value):
            return value
        case .failure:
            return try defaultValue()
        }
}

@_transparent
public func ??? <T>(result: Result<T>, defaultValue: @autoclosure () throws -> Result<T>)
    rethrows -> Result<T> {
        switch result {
        case .success(let value):
            return .success(value)
        case .failure:
            return try defaultValue()
        }
}

@_transparent
public func ??? <T>(result: Result<T>, defaultValue: @autoclosure () throws -> T?)
    rethrows -> T? {
        switch result {
        case .success(let value):
            return value
        case .failure:
            return try defaultValue()
        }
}
