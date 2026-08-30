import Foundation

// Each tutorial step is a TutorialInstruction
struct TutorialInstruction<ParentAction: Equatable>: Equatable {
    // Display information for the UI
    let detail: TutorialDetails
    
    // The action to watch for
    let path: ParentAction
}

// Example: Creating a step
let step = TutorialInstruction(
    detail: TutorialDetails(
        "editButton",
        "Tap the Edit button to customize your plan"
    ),
    path: .tappedEditButton
)
