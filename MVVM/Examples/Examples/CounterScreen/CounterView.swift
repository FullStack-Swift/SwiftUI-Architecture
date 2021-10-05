import SwiftUI

struct CounterView: View {
  
  @ObservedObject
  var viewModel: CounterViewModel
  
  init() {
    viewModel = CounterViewModel(CounterState())
  }
  
  var body: some View {
    HStack {
      Button("+") {
        viewModel.send(.increment)
      }
      Text("\(viewModel.count)")
      Button("-") {
        viewModel.send(.decrement)
      }
    }
  }
}

struct CounterView_Previews: PreviewProvider {
  static var previews: some View {
    CounterView()
  }
}
