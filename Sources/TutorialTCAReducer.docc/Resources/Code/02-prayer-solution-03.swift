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
}
