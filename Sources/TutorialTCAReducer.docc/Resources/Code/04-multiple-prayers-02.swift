import ComposableArchitecture

@Reducer
struct ParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var profile: ProfileFeature.State?
        @Presents var settings: SettingsFeature.State?
        @Presents var workout: WorkoutFeature.State?
        var errorMessage: String?
    }
    
    enum Action {
        case handleError(String)
        case trackAnalytics(String)
        case syncToCloud
        case profile(PresentationAction<ProfileFeature.Action>)
        case settings(PresentationAction<SettingsFeature.Action>)
        case workout(PresentationAction<WorkoutFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .handleError, .trackAnalytics, .syncToCloud:
                return .none
            case .profile, .settings, .workout:
                return .none
            }
        }
        
        // Prayer #1: Error Handling
        Prayer(
            listening: [
                \.profile.presented.failedToSave,
                \.workout.presented.failedToSave
            ],
            answerWith: { errorMessage in
                .handleError(errorMessage)
            }
        )
    }
}
