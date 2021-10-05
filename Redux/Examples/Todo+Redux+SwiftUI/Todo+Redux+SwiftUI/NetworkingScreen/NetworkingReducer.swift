import Foundation
import Redux

let NetworkingReducer: Reducer<NetworkingState> = {state, action in
  guard let action = action as? NetworkingAction else {
    return NetworkingState()
  }
  
  var state = state
  
  switch action {
  case .loadData:
    state.isLoading = true
    state.response = ""
  case .responseData(let string):
    state.isLoading = false
    state.response = string
  }
  
  return state
}
