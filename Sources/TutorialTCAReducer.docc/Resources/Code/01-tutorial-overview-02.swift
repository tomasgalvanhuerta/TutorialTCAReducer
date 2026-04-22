import Foundation
import ComposableArchitecture

/**
 TutorialInstruction - A single step in your tutorial
 
 Components:
 - detail: What to show the user (title + instructions)
 - path: The action the user needs to perform
 */
@available(macOS 14, *)
struct TutorialInstruction<ParentAction: Equatable>: Equatable {
    let detail: TutorialDetails
    let path: ParentAction
}

/**
 TutorialDetails - Display information for a tutorial step
 */
struct TutorialDetails: Equatable, Identifiable {
    let id: UUID
    let displayID: String  // Used for accessibility and testing
    let detail: AttributedString  // Rich text instructions
    
    init(_ displayID: String, _ detail: AttributedString) {
        @Dependency(\.uuid) var uuid
        self.id = uuid()
        self.displayID = displayID
        self.detail = detail
    }
}

// Example: Create a tutorial step
let step = TutorialInstruction(
    detail: TutorialDetails(
        "TapEditButton",
        AttributedString("Tap the **Edit** button to customize your plan")
    ),
    path: .tappedEditPlanButton
)
