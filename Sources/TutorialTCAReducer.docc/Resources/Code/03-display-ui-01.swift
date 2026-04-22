import Foundation
import ComposableArchitecture

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
          if action == state[keyPath: toChildState].currentTutorialStep?.path {
              // Remove the completed step
              state[keyPath: toChildState].steps.removeFirst()
              
              // Notify the UI about the next step (or nil if tutorial is complete)
              tutorial.path(state[keyPath: toChildState].steps.first?.detail)
              
              // If no steps remain, the tutorial is complete
              if state[keyPath: toChildState].steps.isEmpty {
                  tutorial.stopTutorial()
              }
          }
          return .none
      }
}

/**
 The TutorialChannel dependency provides two methods:
 
 1. path(_:) - Called when advancing to a new step
    - Receives TutorialDetails with instructions for the user
    - Use this to show tooltips, highlights, etc.
 
 2. stopTutorial() - Called when all steps are complete
    - Use this to hide tutorial UI and show completion
 */
