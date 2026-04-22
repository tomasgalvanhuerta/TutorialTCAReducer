import Foundation
import ComposableArchitecture

/**
 Tutorial Reducer - Guides users through step-by-step actions
 
 How it works:
 1. You define a sequence of expected actions (steps)
 2. The reducer watches for actions as users interact with your app
 3. When an action matches the current step, it's removed from the list
 4. The next step becomes active
 5. When all steps are complete, the tutorial ends
 */
@available(macOS 14, *)
struct Tutorial<ParentState, ParentAction: Equatable>: Reducer {
    @Dependency(\.tutorial) var tutorial

    typealias ChildState = TutorialState<ParentAction>
    let toChildState: WritableKeyPath<ParentState, ChildState>

    public init(
        _ state: WritableKeyPath<ParentState, ChildState>
    ) {
        self.toChildState = state
    }
    
    public func reduce(
        into state: inout ParentState,
        action: ParentAction
      ) -> Effect<ParentAction> {
          // Check if the action matches the current tutorial step
          if action == state[keyPath: toChildState].currentTutorialStep?.path {
              // Remove completed step
              state[keyPath: toChildState].steps.removeFirst()
              // Notify UI about the next step
              tutorial.path(state[keyPath: toChildState].steps.first?.detail)
          }
          return .none
      }
}
