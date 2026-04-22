import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var createTrainingCycle: CreateTrainingCycleFeature.State?
        @Presents var editPlan: EditPlanFeature.State?
        var errorMessage: String?
    }
    
    enum Action {
        case handleError(String)
        case createTrainingCycle(PresentationAction<CreateTrainingCycleFeature.Action>)
        case editPlan(PresentationAction<EditPlanFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .handleError(message):
                // Centralized error handling!
                state.errorMessage = message
                print("Error occurred: \(message)")
                return .none
                
            case .createTrainingCycle, .editPlan:
                return .none
            }
        }
        
        // Prayer listens for specific child actions
        Prayer(
            listening: [
                \.createTrainingCycle.presented.failedToSave,
                \.editPlan.presented.failedToSave
            ],
            answerWith: { errorMessage in
                .handleError(errorMessage)
            }
        )
        
        // Child reducers
        .ifLet(\.$createTrainingCycle, action: \.createTrainingCycle) {
            CreateTrainingCycleFeature()
        }
        .ifLet(\.$editPlan, action: \.editPlan) {
            EditPlanFeature()
        }
    }
}
