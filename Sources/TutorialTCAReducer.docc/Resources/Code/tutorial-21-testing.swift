import Testing
import ComposableArchitecture

// Test your tutorials

@MainActor
@Suite("Tutorial Reducer Tests")
struct TutorialTests {
    
    @Test("Tutorial advances through steps when actions match")
    func tutorialAdvancesThroughSteps() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
        // Initial state: 3 steps in tutorial
        #expect(store.state.tutorialState.steps.count == 3)
        #expect(store.state.tutorialState.currentTutorialStep?.detail.displayID == "editButton")
        
        // Step 1: User taps edit button
        await store.send(.tappedEditButton) { state in
            state.isEditing = true
        }
        
        // Tutorial should advance - step removed
        #expect(store.state.tutorialState.steps.count == 2)
        #expect(store.state.tutorialState.currentTutorialStep?.detail.displayID == "newPlanButton")
        
        // Step 2: User taps new plan
        await store.send(.tappedNewPlan)
        await store.receive(\.planCreated) { state in
            state.plans.append(Plan())
        }
        
        // Tutorial advances again
        #expect(store.state.tutorialState.steps.count == 1)
        #expect(store.state.tutorialState.currentTutorialStep?.detail.displayID == "nextButton")
        
        // Step 3: User taps next
        await store.send(.tappedNext)
        
        // Tutorial complete - no more steps
        #expect(store.state.tutorialState.steps.isEmpty)
        #expect(store.state.tutorialState.currentTutorialStep == nil)
    }
    
    @Test("Tutorial stays on step when wrong action occurs")
    func tutorialWaitsForCorrectAction() async {
        let store = TestStore(
            initialState: AppFeature.State()
        ) {
            AppFeature()
        }
        
        #expect(store.state.tutorialState.currentTutorialStep?.detail.displayID == "editButton")
        
        // User performs wrong action (new plan instead of edit)
        await store.send(.tappedNewPlan)
        await store.receive(\.planCreated) { state in
            state.plans.append(Plan())
        }
        
        // Tutorial should NOT advance - still waiting for edit button
        #expect(store.state.tutorialState.steps.count == 3)
        #expect(store.state.tutorialState.currentTutorialStep?.detail.displayID == "editButton")
    }
}

struct Plan: Equatable {
    let id = UUID()
}
