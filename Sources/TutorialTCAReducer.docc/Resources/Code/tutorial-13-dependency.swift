import ComposableArchitecture
import Dependencies

// The Tutorial reducer uses the tutorial dependency

struct Tutorial<ParentState, ParentAction: Equatable>: Reducer {
    // Access the tutorial dependency
    @Dependency(\.tutorial) var tutorial

    typealias ChildState = TutorialState<ParentAction>
    let toChildState: WritableKeyPath<ParentState, ChildState>

    public func reduce(
        into state: inout ParentState,
        action: ParentAction
    ) -> Effect<ParentAction> {
        if action == state[keyPath: toChildState].currentTutorialStep?.path {
            state[keyPath: toChildState].steps.removeFirst()
            
            // Communicate to UI via dependency
            if let nextStep = state[keyPath: toChildState].steps.first {
                tutorial.path(nextStep.detail)
            } else {
                // No more steps - tutorial complete!
                tutorial.path(nil) // Triggers stopTutorial()
            }
        }
        return .none
    }
}
