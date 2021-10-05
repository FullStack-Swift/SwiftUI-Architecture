import Foundation
import Combine

@dynamicMemberLookup
public final class ViewStore<State, Action>: ObservableObject {
  
  public private(set) lazy var objectWillChange = ObservableObjectPublisher()
  private let _send: (Action) -> Void
  fileprivate let _state: CurrentValueSubject<State, Never>
  private var viewCancellable: AnyCancellable?
  
  public init( _ store: Store<State, Action>, removeDuplicates isDuplicate: @escaping (State, State) -> Bool) {
    self._send = { store.send($0) }
    self._state = CurrentValueSubject(store.state.value)
    
    self.viewCancellable = store.state
      .removeDuplicates(by: isDuplicate)
      .sink { [weak self] in
        guard let self = self else { return }
        self.objectWillChange.send()
        self._state.value = $0
      }
  }
  
  public subscript<LocalState>(dynamicMember keyPath: KeyPath<State, LocalState>) -> LocalState {
    self._state.value[keyPath: keyPath]
  }
  
  public func send(_ action: Action) {
    self._send(action)
  }
}

extension ViewStore where State: Equatable {
  public convenience init(_ store: Store<State, Action>) {
    self.init(store, removeDuplicates: ==)
  }
}

extension ViewStore where State == Void {
  public convenience init(_ store: Store<Void, Action>) {
    self.init(store, removeDuplicates: ==)
  }
}
