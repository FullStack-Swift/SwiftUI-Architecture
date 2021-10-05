import Foundation
import Combine

@dynamicMemberLookup
open class BaseViewModel<State, Action>: ObservableObject {
    
    public private(set) lazy var objectWillChange = ObservableObjectPublisher()
    fileprivate let _state: CurrentValueSubject<State, Never>
    private var viewCancellable: AnyCancellable?
    
    var effectCancellables: [UUID: AnyCancellable] = [:]
    
    private var reducerEffect: ((inout State, Action) -> AnyPublisher<Action, Never>)?
    
    private var bufferedActions: [Action] = []
    
    private var isSending = false
    
    public init(_ state: State, removeDuplicates isDuplicate: @escaping (State, State) -> Bool) {
        self._state = CurrentValueSubject(state)
        initViewModel(isDuplicate)
        commonInit()
    }
    
    /// please override this method
    open func commonInit() {
        
    }
    
    private func initViewModel(_ isDuplicate: @escaping (State, State) -> Bool) {
         reducerEffect =  { [weak self] state, action in
            self?.reducer(state: &state, action: action) ?? Empty(completeImmediately: true).eraseToAnyPublisher()
        }
        self.viewCancellable = _state
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
        self.bufferedActions.append(action)
        guard !self.isSending else { return }
        
        self.isSending = true
        var currentState = self._state.value
        defer {
            self.isSending = false
            self._state.value = currentState
        }
        
        while !self.bufferedActions.isEmpty {
            let action = self.bufferedActions.removeFirst()
            let effect = self.reducerEffect!(&currentState, action)
            
            var didComplete = false
            let uuid = UUID()
            let effectCancellable = effect.sink(
                receiveCompletion: { [weak self] _ in
                    didComplete = true
                    self?.effectCancellables[uuid] = nil
                },
                receiveValue: { [weak self] action in
                    self?.send(action)
                }
            )
            if !didComplete {
                self.effectCancellables[uuid] = effectCancellable
            }
        }
    }
    
    /// please override this method
    open func reducer(state: inout State, action: Action) -> AnyPublisher<Action, Never> {
//        fatalError()
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
}

extension BaseViewModel where State: Equatable {
    public convenience init(_ state: State) {
        self.init(state, removeDuplicates: ==)
    }
}

extension BaseViewModel where State == Void {
    public convenience init(_ state: State) {
        self.init(state, removeDuplicates: ==)
    }
}
