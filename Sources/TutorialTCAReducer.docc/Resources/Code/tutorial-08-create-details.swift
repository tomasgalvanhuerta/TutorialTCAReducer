import SwiftUI

// Step 4: Create TutorialDetails for each step

enum CreatePlanTutorialStep: String {
    case editButton
    case newPlanButton
    case nextButton
}

// Create details with helpful instructions
let editButtonDetail = TutorialDetails(
    CreatePlanTutorialStep.editButton.rawValue,
    AttributedString("Tap the Edit button to start customizing your plan")
)

let newPlanDetail = TutorialDetails(
    CreatePlanTutorialStep.newPlanButton.rawValue,
    AttributedString("Now tap New Plan to create a fresh plan")
)

let nextButtonDetail = TutorialDetails(
    CreatePlanTutorialStep.nextButton.rawValue,
    AttributedString("Tap Next to proceed to the plan editor")
)
