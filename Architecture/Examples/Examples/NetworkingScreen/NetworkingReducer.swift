import Foundation
import Combine
import Architecture

let NetworkingReducer = Reducer<NetworkingState, NetworkingAction> { state, action in
  
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
