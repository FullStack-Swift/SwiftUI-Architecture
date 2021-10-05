import SwiftUI

struct NetworkingView: View {
  
  @ObservedObject
  var viewModel: NetworkingViewModel
  
  init() {
    viewModel = NetworkingViewModel(NetworkingState())
  }
  var body: some View {
    VStack {
      if !viewModel.response.isEmpty {
        Text(viewModel.response)
          .lineLimit(10)
      }
      Button( viewModel.isLoading ? "Loading" : "Load") {
        viewModel.send(.loadData)
      }
      .disabled(viewModel.isLoading)
    }
  }
}

struct NetworkingView_Previews: PreviewProvider {
  static var previews: some View {
    NetworkingView()
  }
}
