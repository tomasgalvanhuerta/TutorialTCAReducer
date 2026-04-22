import ComposableArchitecture

// Traditional approach: Parent must handle child actions explicitly

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var childState = ChildFeature.State()
        var errorMessage: String?
    }
    
    @CasePathable
    enum Action: Equatable {
        case child(ChildFeature.Action)
        case handleError(String)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.childState, action: \.child) {
            ChildFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .handleError(let error):
                state.errorMessage = error
                return .none
                
            case .child:
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
