import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var createTrainingCycle: CreateTrainingCycleFeature.State?
        @Presents var editPlan: EditPlanFeature.State?
    }
}
