import Foundation
import Combine

public let asyncActionsMiddleware: Middleware<ReduxState> = { dispatch, state in
    return { next in
        return { action in
            if let asyncAction = action as? AsyncAction {
                asyncAction.execute(dispatch: dispatch, state: state())
            } else {
                next(action)
            }
        }
    }
}

final public class Store<StoreState: ReduxState>: ObservableObject {
    
    @Published public var state: StoreState
    
    private var dispatchFunction: DispatchFunction!
    private let reducer: Reducer<StoreState>
    
    
    public init(state: StoreState, reducer: @escaping Reducer<StoreState>, middleware: [Middleware<StoreState>] = []) {
        self.reducer = reducer
        self.state = state
        
        var middleware = middleware
        middleware.append(asyncActionsMiddleware)
        self.dispatchFunction = middleware
            .reversed()
            .reduce(
                { [unowned self] action in
                    self._dispatch(action: action) },
                { dispatchFunction, middleware in
                    let dispatch: (Action) -> Void = { [weak self] in self?.dispatch(action: $0) }
                    let getState = { [weak self] in self?.state }
                    return middleware(dispatch, getState)(dispatchFunction)
                })
        
    }
    
    public func dispatch(action: Action) {
        DispatchQueue.main.async { [weak self] in
            self?.dispatchFunction(action)
        }
    }
    
    private func _dispatch(action: Action) {
        state = reducer(state, action)
    }
}
