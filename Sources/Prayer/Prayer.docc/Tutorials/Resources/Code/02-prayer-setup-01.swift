import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var createTrainingCycle: CreateTrainingCycleFeature.State?
        @Presents var editPlan: EditPlanFeature.State?
    }
    
    enum Action {
        case handleError(String)
        case createTrainingCycle(PresentationAction<CreateTrainingCycleFeature.Action>)
        case editPlan(PresentationAction<EditPlanFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .handleError:
                return .none
                
            case .createTrainingCycle, .editPlan:
                return .none
            }
        }
    }
}
