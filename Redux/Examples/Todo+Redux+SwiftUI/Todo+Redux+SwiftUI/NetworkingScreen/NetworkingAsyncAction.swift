import Foundation
import Redux

struct NetworkingAsyncAction {
  
  struct ResponseData: AsyncAction {
    func execute(dispatch: @escaping DispatchFunction, state: ReduxState?) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        dispatch(NetworkingAction.responseData("I'm data load from networking"))
      }
    }
  }
}
