import ComposableArchitecture

// Traditional approach with multiple children requires lots of boilerplate

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var childState = ChildFeature.State()
        var anotherChildState = AnotherChildFeature.State()
        var errorMessage: String?
    }
    
    @CasePathable
    enum Action: Equatable {
        case child(ChildFeature.Action)
        case anotherChild(AnotherChildFeature.Action)
        case handleError(String)
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
            case .handleError(let error):
                state.errorMessage = error
                return .none
                
            // Must explicitly handle each child's failure action
            case .child(.failedToSave(let error)):
                state.errorMessage = error
                return .none
                
            case .anotherChild(.failedToLoad(let error)):
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
