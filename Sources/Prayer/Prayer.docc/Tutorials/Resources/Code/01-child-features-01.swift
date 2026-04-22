import ComposableArchitecture

@Reducer
struct CreateTrainingCycleFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case failedToSave(String)
        case success
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .failedToSave:
                return .none
            case .success:
                return .none
            }
        }
    }
}

@Reducer
struct EditPlanFeature {
    @ObservableState
    struct State: Equatable {}
    
    enum Action {
        case failedToSave(String)
        case dataSaved
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .failedToSave:
                return .none
            case .dataSaved:
                return .none
            }
        }
    }
}
