import SwiftUI
import Architecture

struct NetworkingView: View {
  
  @ObservedObject
  private var viewStore: ViewStore<NetworkingState, NetworkingAction>
  
  init() {
    viewStore = ViewStore(Store(state: NetworkingState(), reducer: NetworkingReducer))
  }
  var body: some View {
    VStack {
      if !viewStore.response.isEmpty {
        Text(viewStore.response)
          .lineLimit(10)
      }
      Button( viewStore.isLoading ? "Loading" : "Load") {
        viewStore.send(.loadData)
      }
      .disabled(viewStore.isLoading)
    }
  }
}

struct NetworkingView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkingView()
  }
}
