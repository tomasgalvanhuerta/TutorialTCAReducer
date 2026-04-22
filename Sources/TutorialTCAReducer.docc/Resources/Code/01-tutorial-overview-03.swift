import Foundation
import ComposableArchitecture

/**
 TutorialState - Manages the current tutorial
 
 Properties:
 - steps: Array of remaining tutorial instructions
 - title: Overall title for the tutorial
 - currentTutorialStep: Computed property for the active step
 */
@available(macOS 14, *)
@ObservableState
struct TutorialState<ParentAction: Equatable>: Equatable {
    typealias Path = TutorialInstruction<ParentAction>
    
    var steps: [Path]
    let title: String
    
    // The current step is always the first in the array
    var currentTutorialStep: Path? {
        steps.first
    }
    
    init(steps: [Path], title: String) {
        self.steps = steps
        self.title = title
    }
}

// Example: Initialize a tutorial state
let tutorialState = TutorialState<MyDomain.Action>(
    steps: [
        .init(
            detail: .init("Step1", AttributedString("First, tap this")),
            path: .action1
        ),
        .init(
            detail: .init("Step2", AttributedString("Then, tap that")),
            path: .action2
        )
    ],
    title: "Getting Started Tutorial"
)
