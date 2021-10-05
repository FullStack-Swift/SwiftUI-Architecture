import Foundation

let CounterReducer: Reducer<CounterState> = {state, action in
    guard let action = action as? CounterAction else {
        return CounterState()
    }
    
    var state = state
    
    switch action {
    case .increment:
        state.number += 1
    case .decrement:
        state.number -= 1
    }
    return state
}
