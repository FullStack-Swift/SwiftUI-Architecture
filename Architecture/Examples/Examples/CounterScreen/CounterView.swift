import SwiftUI
import Architecture

struct CounterView: View {
  @ObservedObject
  private var viewStore: ViewStore<CounterState, CounterAction>
  
  init() {
    viewStore = ViewStore(Store(state: CounterState(), reducer: CounterReducer))
  }
  var body: some View {
    HStack {
      Button("+") {
        viewStore.send(.increment)
      }
      Text("\(viewStore.count)")
      Button("-") {
        viewStore.send(.decrement)
      }
    }
  }
}

struct CounterView_Previews: PreviewProvider {
  static var previews: some View {
    CounterView()
  }
}
