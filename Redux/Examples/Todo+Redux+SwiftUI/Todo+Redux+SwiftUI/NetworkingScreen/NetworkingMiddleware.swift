import Foundation
import Redux

let NetworkingMiddleware: Middleware<NetworkingState> = createThunkMiddleware()

public func createThunkMiddleware<State>() -> Middleware<State> {
  return { dispatch, getState in
    return { next in
      return { action in
        switch action {
        case let thunk as Thunk<State>:
          thunk.body(dispatch, getState)
        default:
          next(action)
        }
      }
    }
  }
}

let networkingMiddlewareThunk: Thunk<NetworkingState> = Thunk{ dispatch, state in
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    dispatch(NetworkingAction.responseData("I'm data load from networking"))
  }
}
