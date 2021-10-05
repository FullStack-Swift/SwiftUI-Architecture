import Combine
import Foundation

public final class Store<State, Action> {
  
  var state: CurrentValueSubject<State, Never>
  
  var effectCancellables: [UUID: AnyCancellable] = [:]
  
  private let reducer: (inout State, Action) -> AnyPublisher<Action, Never>
  
  private var bufferedActions: [Action] = []
  
  private var isSending = false
  
  public init(state: State, reducer: Reducer<State, Action>) {
    self.state = CurrentValueSubject(state)
    self.reducer =  { state, action in
      reducer.run(&state, action)
    }
    
  }
  
  func send(_ action: Action) {
    self.bufferedActions.append(action)
    guard !self.isSending else { return }
    
    self.isSending = true
    var currentState = self.state.value
    defer {
      self.isSending = false
      self.state.value = currentState
    }
    
    while !self.bufferedActions.isEmpty {
      let action = self.bufferedActions.removeFirst()
      let effect = self.reducer(&currentState, action)
      
      var didComplete = false
      let uuid = UUID()
      let effectCancellable = effect.sink(
        receiveCompletion: { [weak self] _ in
          didComplete = true
          
          self?.effectCancellables[uuid] = nil
        },
        receiveValue: { [weak self] action in
          self?.send(action)
        }
      )
      if !didComplete {
        self.effectCancellables[uuid] = effectCancellable
      }
    }
  }
}
