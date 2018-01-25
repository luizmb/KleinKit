import Foundation
import KleinKit

public protocol ActionDispatcher {
    func dispatch(_ action: Action)
    func async<AppActionAsyncType: AppActionAsync>(_ action: AppActionAsyncType)
}

