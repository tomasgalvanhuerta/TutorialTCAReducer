import ComposableArchitecture
import SwiftUI

// Step 5: Create TutorialInstruction objects combining details and paths

let createPlanSteps: [TutorialInstruction<AppFeature.Action>] = [
    // Step 1: Edit button
    TutorialInstruction(
        detail: TutorialDetails(
            "editButton",
            AttributedString("Tap the Edit button to start customizing")
        ),
        path: .tappedEditButton
    ),
    
    // Step 2: New plan button
    TutorialInstruction(
        detail: TutorialDetails(
            "newPlanButton",
            AttributedString("Now tap New Plan to create a fresh plan")
        ),
        path: .tappedNewPlan
    ),
    
    // Step 3: Next button
    TutorialInstruction(
        detail: TutorialDetails(
            "nextButton",
            AttributedString("Tap Next to proceed to the plan editor")
        ),
        path: .tappedNext
    )
]
