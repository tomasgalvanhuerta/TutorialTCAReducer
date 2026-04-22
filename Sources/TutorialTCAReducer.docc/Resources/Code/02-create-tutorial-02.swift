import Foundation
import ComposableArchitecture

@Reducer
struct PlanDomain {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditingPlan = false
        
        // Add tutorial state to track guided experiences
        var tutorialState = TutorialState<Action>(
            steps: [],
            title: ""
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
    }
}

struct Plan: Equatable, Identifiable {
    let id: UUID
    let name: String
}
