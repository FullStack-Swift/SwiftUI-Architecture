import SwiftUI

struct ContentView: View {
  
  var body: some View {
    TabView {
      CounterView()
        .tabItem {
          VStack {
            Text("Synchronous")
            Image(systemName: "heart")
            
          }
        }
      NetworkingView()
        .tabItem {
          VStack {
            Text("Asynchronous")
            Image(systemName: "tornado")
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
