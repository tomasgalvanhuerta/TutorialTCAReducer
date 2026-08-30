import ComposableArchitecture
import SwiftUI

// Step 7: Add Tutorial reducer to your feature's body

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditing = false
        var tutorialState: TutorialState<Action>
        
        init() {
            self.tutorialState = TutorialState(
                steps: [
                    TutorialInstruction(
                        detail: TutorialDetails("editButton", "Tap Edit"),
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
            switch action {
            case .tappedEditButton:
                state.isEditing = true
                return .none
            case .tappedNewPlan:
                return .run { send in
                    await send(.planCreated(Plan()))
                }
            case .tappedNext:
                return .none
            case .planCreated(let plan):
                state.plans.append(plan)
                return .none
            }
        }
        
        // Add Tutorial reducer - pass keypath to tutorial state
        Tutorial(\.tutorialState)
    }
}

struct Plan: Equatable {
    let id = UUID()
    var title = "New Plan"
}
