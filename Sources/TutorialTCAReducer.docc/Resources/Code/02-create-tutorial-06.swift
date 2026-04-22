import Foundation
import ComposableArchitecture

@Reducer
struct PlanDomain {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditingPlan = false
        
        var tutorialState = TutorialState<Action>(
            steps: [
                .init(
                    detail: .init("EditPlanButton", AttributedString("Tap the **Edit Plan** button")),
                    path: .tappedEditPlanButton
                ),
                .init(
                    detail: .init("NewPlanButton", AttributedString("Now tap **New Plan**")),
                    path: .tappedNewPlanButton
                ),
                .init(
                    detail: .init("NextButton", AttributedString("Tap **Next** to continue")),
                    path: .tappedNextButton
                )
            ],
            title: "Create Your First Plan"
        )
    }
    
    @CasePathable
    enum Action: Equatable {
        case tappedEditPlanButton
        case tappedNewPlanButton
        case tappedNextButton
        case planCreated(Plan)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedEditPlanButton:
                state.isEditingPlan = true
                return .none
            case .tappedNewPlanButton:
                return .none
            case .tappedNextButton:
                return .none
            case .planCreated(let plan):
                state.plans.append(plan)
                return .none
            }
        }
        
        Tutorial(\.tutorialState)
    }
}

struct Plan: Equatable, Identifiable {
    let id: UUID
    let name: String
}

// What happens when the user taps the Edit Plan button:
// 1. The action .tappedEditPlanButton is sent to the store
// 2. The Reduce reducer handles it normally (sets isEditingPlan = true)
// 3. The Tutorial reducer checks if .tappedEditPlanButton matches the current step
// 4. It matches! The first step is removed from tutorialState.steps
// 5. The tutorial advances to the next step (.tappedNewPlanButton)
// 6. The UI is notified via the tutorial dependency
