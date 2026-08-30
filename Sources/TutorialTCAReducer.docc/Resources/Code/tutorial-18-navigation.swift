import ComposableArchitecture
import SwiftUI

// Multi-screen tutorial with navigation actions

@Reducer
struct MultiScreenFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var detailScreen: DetailFeature.State?
        var tutorialState: TutorialState<Action>
        
        init() {
            self.tutorialState = TutorialState(
                steps: [
                    // Step 1: On home screen
                    TutorialInstruction(
                        detail: TutorialDetails(
                            "settingsButton",
                            "Tap Settings to begin"
                        ),
                        path: .tappedSettings
                    ),
                    
                    // Step 2: Navigation action
                    TutorialInstruction(
                        detail: TutorialDetails(
                            "navigation",
                            "Opening settings..."
                        ),
                        path: .detailScreen(.presented(.appeared))
                    ),
                    
                    // Step 3: On detail screen
                    TutorialInstruction(
                        detail: TutorialDetails(
                            "saveButton",
                            "Now tap Save on the settings screen"
                        ),
                        path: .detailScreen(.presented(.tappedSave))
                    )
                ],
                title: "Configure Settings"
            )
        }
    }
    
    @CasePathable
    enum Action: Equatable {
        case tappedSettings
        case detailScreen(PresentationAction<DetailFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .tappedSettings:
                state.detailScreen = DetailFeature.State()
                return .none
            case .detailScreen:
                return .none
            }
        }
        
        Tutorial(\.tutorialState)
        
        .ifLet(\.$detailScreen, action: \.detailScreen) {
            DetailFeature()
        }
    }
}

@Reducer
struct DetailFeature {
    struct State: Equatable {}
    enum Action: Equatable {
        case appeared
        case tappedSave
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in .none }
    }
}
