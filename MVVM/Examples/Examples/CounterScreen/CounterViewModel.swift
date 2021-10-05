import Foundation
import Combine
import MVVM

final class CounterViewModel: BaseViewModel<CounterState, CounterAction> {
  
  override func commonInit() {
    // TODO someting
  }
  
  override func reducer(state: inout CounterState, action: CounterAction) -> AnyPublisher<CounterAction, Never> {
    switch action {
    case .increment:
      state.count += 1
    case .decrement:
      state.count -= 1
    }
    return Empty(completeImmediately: true).eraseToAnyPublisher()
  }
}
