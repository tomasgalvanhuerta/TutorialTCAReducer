import ComposableArchitecture
import SwiftUI

// Step 6: Initialize TutorialState with steps and title

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditing = false
        var tutorialState: TutorialState<Action>
        
        // Initialize with tutorial
        init() {
            self.tutorialState = TutorialState(
                steps: [
                    TutorialInstruction(
                        detail: TutorialDetails("editButton", "Tap Edit to customize"),
                        path: .tappedEditButton
                    ),
                    TutorialInstruction(
                        detail: TutorialDetails("newPlanButton", "Tap New Plan"),
                        path: .tappedNewPlan
                    ),
                    TutorialInstruction(
                        detail: TutorialDetails("nextButton", "Tap Next"),
                        path: .tappedNext
                    )
                ],
                title: "Create Your First Plan"
            )
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case tappedEditButton
        case tappedNewPlan
        case tappedNext
        case planCreated(Plan)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // ... reducer logic
            .none
        }
    }
}

struct Plan: Equatable {
    let id = UUID()
    var title = "New Plan"
}
