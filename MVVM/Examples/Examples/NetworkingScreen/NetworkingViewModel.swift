import Foundation
import Combine
import MVVM

final class NetworkingViewModel: BaseViewModel<NetworkingState, NetworkingAction> {
  
  override func commonInit() {
    // TODO someting
  }
  
  override func reducer(state: inout NetworkingState, action: NetworkingAction) -> AnyPublisher<NetworkingAction, Never> {
    switch action {
    case .loadData:
      state.isLoading = true
      state.response = ""
      return Just(.responseData("I'm data load from networking"))
        .delay(for: 2, scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    case .responseData(let string):
      state.isLoading = false
      state.response = string
      break
    }
    
    return Empty(completeImmediately: true).eraseToAnyPublisher()
  }
}
