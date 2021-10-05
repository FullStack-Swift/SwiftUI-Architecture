import Foundation

public protocol AsyncAction: Action {
    func execute(dispatch: @escaping DispatchFunction, state: ReduxState?)
}
