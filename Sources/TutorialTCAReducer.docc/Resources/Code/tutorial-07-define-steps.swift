import ComposableArchitecture

// Step 3: Define your tutorial steps

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var plans: [Plan] = []
        var isEditing = false
        var tutorialState: TutorialState<Action>
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

// Define display IDs for your tutorial steps
enum CreatePlanTutorialStep: String {
    case editButton
    case newPlanButton
    case nextButton
}

// Define the action paths users will take
// Step 1: User taps edit button
// Step 2: User taps new plan
// Step 3: User taps next

struct Plan: Equatable {
    let id = UUID()
    var title = "New Plan"
}
