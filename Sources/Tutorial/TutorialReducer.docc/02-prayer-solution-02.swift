import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
    }
    
    @CasePathable
    enum Action: Equatable {
        case handleError(String)
    }
}
