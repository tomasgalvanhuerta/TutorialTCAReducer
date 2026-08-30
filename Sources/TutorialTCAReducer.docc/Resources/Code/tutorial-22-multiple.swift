import ComposableArchitecture
import SwiftUI

// Create multiple tutorials for different features

@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var tutorialState: TutorialState<Action>?
        var availableTutorials: [AvailableTutorial] = [
            .createPlan,
            .shareWithTeam,
            .customizeSettings
        ]
        
        init() {
            // Start with no active tutorial
            self.tutorialState = nil
        }
        
        mutating func startTutorial(_ tutorial: AvailableTutorial) {
            switch tutorial {
            case .createPlan:
                self.tutorialState = createPlanTutorial()
            case .shareWithTeam:
                self.tutorialState = shareWithTeamTutorial()
            case .customizeSettings:
                self.tutorialState = customizeSettingsTutorial()
            }
        }
    }
    
    enum AvailableTutorial: String, CaseIterable, Identifiable {
        case createPlan = "Create Your First Plan"
        case shareWithTeam = "Share with Team Members"
        case customizeSettings = "Customize Your Settings"
        
        var id: String { rawValue }
    }
    
    @CasePathable
    enum Action: Equatable {
        case startTutorial(AvailableTutorial)
        case tappedEditButton
        case tappedNewPlan
        case tappedNext
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startTutorial(let tutorial):
                state.startTutorial(tutorial)
                return .none
            case .tappedEditButton:
                return .none
            case .tappedNewPlan:
                return .none
            case .tappedNext:
                return .none
            }
        }
        
        // Tutorial reducer only activates if tutorialState is set
        .ifLet(\.tutorialState, action: \.self) {
            Tutorial(\.tutorialState!)
        }
    }
}

// Tutorial factory functions
func createPlanTutorial() -> TutorialState<AppFeature.Action> {
    TutorialState(
        steps: [
            TutorialInstruction(
                detail: TutorialDetails("edit", "Tap Edit"),
                path: .tappedEditButton
            )
        ],
        title: "Create Your First Plan"
    )
}

func shareWithTeamTutorial() -> TutorialState<AppFeature.Action> {
    TutorialState(steps: [], title: "Share with Team")
}

func customizeSettingsTutorial() -> TutorialState<AppFeature.Action> {
    TutorialState(steps: [], title: "Customize Settings")
}
