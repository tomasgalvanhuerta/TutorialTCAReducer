import Foundation
import ComposableArchitecture

enum CreatePlanTutorial: String {
    case editButton = "EditPlanButton"
    case newPlanButton = "NewPlanButton"
    case nextButton = "NextButton"
}

@Reducer
struct PlanDomain {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditingPlan = false
        
        var tutorialState = TutorialState<Action>(
            steps: [
                .init(
                    detail: .init(
                        CreatePlanTutorial.editButton.rawValue,
                        AttributedString("Tap the **Edit Plan** button to start customizing")
                    ),
                    path: .tappedEditPlanButton
                ),
                .init(
                    detail: .init(
                        CreatePlanTutorial.newPlanButton.rawValue,
                        AttributedString("Now tap **New Plan** to create your first plan")
                    ),
                    path: .tappedNewPlanButton
                ),
                .init(
                    detail: .init(
                        CreatePlanTutorial.nextButton.rawValue,
                        AttributedString("Tap **Next** to continue setting up your plan")
                    ),
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
        
        // Add Tutorial reducer to watch for actions
        Tutorial(\.tutorialState)
    }
}

struct Plan: Equatable, Identifiable {
    let id: UUID
    let name: String
}
