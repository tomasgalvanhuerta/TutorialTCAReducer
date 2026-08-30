import ComposableArchitecture

// How the Tutorial reducer works at runtime

// When user taps the Edit button:
// 1. Action .tappedEditButton flows through reducers
// 2. Your Reduce handles it (sets isEditing = true)
// 3. Tutorial reducer receives the same action

// Tutorial reducer logic:
if action == state.tutorialState.currentTutorialStep?.path {
    // Action matches! Current step is .tappedEditButton
    
    // Remove completed step
    state.tutorialState.steps.removeFirst()
    // Steps now: [newPlanButton, nextButton]
    
    // Notify UI of next step
    tutorial.path(state.tutorialState.steps.first?.detail)
    // UI receives: "Tap New Plan" instruction
}

// User sees highlight move to the New Plan button!
// Tutorial waits for .tappedNewPlan action...
