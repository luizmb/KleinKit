import Foundation
import KleinKit

public struct EntryPointReducer: Reducer {

    public init() { }

    public typealias StateType = AppState
    private let reducers: [AnyReducer<AppState>] = []

    public func reduce(_ currentState: AppState, action: Action) -> AppState {
        return reducers.reduce(currentState) { $1.reduce($0, action: action) }
    }
}
