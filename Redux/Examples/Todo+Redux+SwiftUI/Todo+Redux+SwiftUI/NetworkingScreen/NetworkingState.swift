import Foundation
import Redux

struct NetworkingState: ReduxState {
  var response: String = ""
  var isLoading: Bool = false
}
