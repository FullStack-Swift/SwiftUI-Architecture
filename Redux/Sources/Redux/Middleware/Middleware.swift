import Foundation

public typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> State?) -> (@escaping DispatchFunction) -> DispatchFunction
