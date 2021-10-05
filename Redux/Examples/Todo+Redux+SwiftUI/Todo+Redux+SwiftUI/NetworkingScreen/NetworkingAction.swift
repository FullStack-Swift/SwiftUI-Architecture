import Foundation
import Redux

enum NetworkingAction: Action {
  case loadData
  case responseData(String)
}
