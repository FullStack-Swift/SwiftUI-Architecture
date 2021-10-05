import Foundation

public struct Thunk<State>: Action {
  
  public let body: (_ dispatch: @escaping DispatchFunction, _ getState: @escaping () -> State?) -> Void
  
  public init(body: @escaping (_ dispatch: @escaping DispatchFunction,_ getState: @escaping () -> State?) -> Void) {
    self.body = body
  }
}
