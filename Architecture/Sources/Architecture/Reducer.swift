import Foundation
import Combine

public struct Reducer<State, Action> {
  
  private let reducer: (inout State, Action) -> AnyPublisher<Action, Never>
  
  public init(_ reducer: @escaping (inout State, Action) -> AnyPublisher<Action, Never>) {
    self.reducer = reducer
  }
  
  public func run(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Never> {
    self.reducer(&state, action)
  }
  
}
