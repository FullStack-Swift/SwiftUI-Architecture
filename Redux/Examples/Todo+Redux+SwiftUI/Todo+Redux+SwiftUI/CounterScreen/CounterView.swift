import SwiftUI

struct CounterView: View {
    
    @ObservedObject
    var store: Store<CounterState>
    
    init() {
        store = Store(state: CounterState(), reducer: CounterReducer, middleware: [])
    }
    
    var body: some View {
        HStack {
            Button("+") {
                store.dispatch(action: CounterAction.increment)
            }
            Text("\(store.state.number)")
            Button("-") {
                store.dispatch(action: CounterAction.decrement)
            }
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView()
    }
}
