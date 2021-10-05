import SwiftUI
import Redux

struct NetworkingView: View {
  
  @ObservedObject
  var store: Store<NetworkingState>
  
  init() {
    store = Store(state: NetworkingState(), reducer: NetworkingReducer, middleware: [NetworkingMiddleware])
  }
  var body: some View {
    VStack {
      if !store.state.response.isEmpty {
        Text(store.state.response)
          .lineLimit(10)
      }
      Button( store.state.isLoading ? "Loading" : "Load") {
        store.dispatch(action: NetworkingAction.loadData)
        store.dispatch(action: NetworkingAsyncAction.ResponseData())
        store.dispatch(action: networkingMiddlewareThunk)
      }
      .disabled(store.state.isLoading)
    }
  }
}

struct NetworkingView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkingView()
  }
}
