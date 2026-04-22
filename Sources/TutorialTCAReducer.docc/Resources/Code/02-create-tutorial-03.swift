import Foundation
import ComposableArchitecture

// Define display IDs for each tutorial step
enum CreatePlanTutorial: String {
    case editButton = "EditPlanButton"
    case newPlanButton = "NewPlanButton"
    case nextButton = "NextButton"
}

// Create tutorial instructions with helpful guidance
let createPlanTutorialSteps: [TutorialInstruction<PlanDomain.Action>] = [
    // Step 1: Tell user to tap Edit button
    .init(
        detail: .init(
            CreatePlanTutorial.editButton.rawValue,
            AttributedString("Tap the **Edit Plan** button to start customizing")
        ),
        path: .tappedEditPlanButton
    ),
    
    // Step 2: Guide them to create a new plan
    .init(
        detail: .init(
            CreatePlanTutorial.newPlanButton.rawValue,
            AttributedString("Now tap **New Plan** to create your first plan")
        ),
        path: .tappedNewPlanButton
    ),
    
    // Step 3: Move to the next screen
    .init(
        detail: .init(
            CreatePlanTutorial.nextButton.rawValue,
            AttributedString("Tap **Next** to continue setting up your plan")
        ),
        path: .tappedNextButton
    )
]
