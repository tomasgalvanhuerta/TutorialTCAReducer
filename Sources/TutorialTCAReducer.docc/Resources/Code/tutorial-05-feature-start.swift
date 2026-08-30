import ComposableArchitecture

// Step 1: Start with your normal TCA feature

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditing = false
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
                    let newPlan = Plan()
                    await send(.planCreated(newPlan))
                }
                
            case .tappedNext:
                return .none
                
            case .planCreated(let plan):
                state.plans.append(plan)
                return .none
            }
        }
    }
}

struct Plan: Equatable {
    let id = UUID()
    var title = "New Plan"
}
