import ComposableArchitecture

// The Tutorial reducer monitors actions and compares them
// against a sequence of expected steps

struct Tutorial<ParentState, ParentAction: Equatable>: Reducer {
    @Dependency(\.tutorial) var tutorial

    typealias ChildState = TutorialState<ParentAction>
    let toChildState: WritableKeyPath<ParentState, ChildState>

    public init(_ state: WritableKeyPath<ParentState, ChildState>) {
        self.toChildState = state
    }
    
    public func reduce(
        into state: inout ParentState,
        action: ParentAction
    ) -> Effect<ParentAction> {
        // Compare the action against the current step
        if action == state[keyPath: toChildState].currentTutorialStep?.path {
            // Match! Remove this step and advance
            state[keyPath: toChildState].steps.removeFirst()
            
            // Notify UI of the next step
            tutorial.path(state[keyPath: toChildState].steps.first?.detail)
        }
        return .none
    }
}
