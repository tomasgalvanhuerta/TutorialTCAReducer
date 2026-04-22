import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
        var childState = ChildFeature.State()
        var anotherChildState = AnotherChildFeature.State()
    }
    
    @CasePathable
    enum Action: Equatable {
        case handleError(String)
        case child(ChildFeature.Action)
        case anotherChild(AnotherChildFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.childState, action: \.child) {
            ChildFeature()
        }
        
        Scope(state: \.anotherChildState, action: \.anotherChild) {
            AnotherChildFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .handleError(error):
                state.errorMessage = error
                return .none
                
            case .child, .anotherChild:
                return .none
            }
        }
    }
}

@Reducer
struct ChildFeature {
    @ObservableState
    struct State: Equatable {}
    
    @CasePathable
    enum Action: Equatable {
        case failedToSave(String)
        case succeeded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
    }
}

@Reducer
struct AnotherChildFeature {
    @ObservableState
    struct State: Equatable {}
    
    @CasePathable
    enum Action: Equatable {
        case failedToLoad(String)
        case loaded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
    }
}
