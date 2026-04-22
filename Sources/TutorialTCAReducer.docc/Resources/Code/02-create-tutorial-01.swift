import Foundation
import ComposableArchitecture

// Step 1: Define your domain with user actions
@Reducer
struct PlanDomain {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditingPlan = false
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
                // Navigate to new plan creation
                return .none
                
            case .tappedNextButton:
                // Proceed to next screen
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
