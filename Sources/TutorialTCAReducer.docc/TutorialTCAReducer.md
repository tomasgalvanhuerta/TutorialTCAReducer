# ``TutorialTCAReducer``

@Metadata {
    @DisplayName("TutorialTCAReducer")
    @TitleHeading("Framework")
}

Advanced reducer patterns for The Composable Architecture: Prayer for cross-cutting concerns and Tutorial for step-by-step user guidance.

## Overview

**TutorialTCAReducer** provides two powerful reducer patterns that solve common challenges in Composable Architecture applications:

1. **Prayer Reducer** - Eliminate boilerplate action forwarding in nested feature hierarchies
2. **Tutorial Reducer** - Guide users through sequential workflows with real-time step tracking

Both patterns leverage TCA's case path system to provide type-safe, declarative solutions to complex problems.

---

## Prayer Reducer

### The Problem: Action Forwarding Boilerplate

In traditional TCA, handling child actions requires explicit forwarding through every level:

```swift
Reduce { state, action in
    switch action {
    case .child(.failedToSave(let error)):
        state.errorMessage = error
        return .none
    case .anotherChild(.failedToLoad(let error)):
        state.errorMessage = error
        return .none
    case .yetAnotherChild(.failedToUpdate(let error)):
        state.errorMessage = error
        return .none
    // ... repetitive boilerplate for each child
    }
}
```

This becomes unmaintainable with multiple children or deep nesting.

### The Solution: Declarative Listening

Prayer reducers listen for specific actions and transform them automatically:

```swift
Prayer(
    listening: [
        \.child.failedToSave,
        \.anotherChild.failedToLoad,
        \.yetAnotherChild.failedToUpdate
    ],
    answerWith: { error in
        .handleError(error)
    }
)
```

Clean, declarative, and maintainable! ✨

### Prayer Use Cases

- 🚨 **Error Handling** - Centralize error management from all features
- 📊 **Analytics Tracking** - Automatically log events across your app
- 🔄 **Side Effect Coordination** - Trigger syncing, caching, or other operations
- 🎯 **Cross-Feature Communication** - Let features react without tight coupling
- 📝 **Audit Logging** - Track important actions for compliance

---

## Tutorial Reducer

### The Problem: Multi-Step Workflows

Building interactive tutorials or onboarding flows requires tracking which steps users have completed and ensuring they follow the correct sequence:

```swift
// Traditional approach: manually track every step
case .tappedButton:
    if state.currentStep == .step1 {
        state.currentStep = .step2
        state.completedSteps.append(.step1)
    }
// ... complex state management for each step
```

This becomes error-prone with complex workflows.

### The Solution: Declarative Step Tracking

Tutorial reducer watches for specific actions and automatically advances through your defined steps:

```swift
// Define your tutorial steps
let createPlanTutorial: TutorialState<AppAction> = .init(
    steps: [
        .init(displayID: "customizePlan", path: .tappedEditButton),
        .init(displayID: "newPlan", path: .presentNewPlan),
        .init(displayID: "nextEdit", path: .nextEdit)
    ],
    title: "Create Your First Plan"
)

// Add to your reducer
Tutorial(\.tutorialState)
```

The reducer automatically:
- Tracks which step the user is on
- Validates actions match expected steps
- Removes completed steps
- Provides current step information for UI highlights

### Tutorial Use Cases

- 🎓 **Onboarding Flows** - Guide new users through your app
- 🎯 **Feature Discovery** - Highlight new capabilities step-by-step
- ✅ **Task Checklists** - Track completion of multi-step processes
- 🎮 **Interactive Tutorials** - Build engaging learning experiences
- 🔄 **Workflow Validation** - Ensure users complete required steps in order

### How Tutorial Works

1. **Define Steps**: Create a `TutorialState` with an array of expected actions
2. **Match Actions**: Tutorial compares incoming actions against the current step
3. **Auto-Advance**: When actions match, the step is removed and moves to the next
4. **UI Integration**: Use `currentTutorialStep` to highlight UI elements
5. **Completion**: When all steps are completed, the tutorial is done

Example with UI integration:

```swift
struct OnboardingView: View {
    let store: StoreOf<OnboardingFeature>
    
    var body: some View {
        VStack {
            Button("Create Plan") {
                store.send(.tappedCreatePlan)
            }
            .overlay {
                if store.tutorialState.displayID == "createPlan" {
                    TutorialHighlight(store.tutorialState.currentTutorialStep?.detail)
                }
            }
        }
    }
}
```

---

## Combining Prayer and Tutorial

These patterns work beautifully together! Use Tutorial to guide users through workflows while Prayer handles cross-cutting concerns:

```swift
var body: some ReducerOf<Self> {
    // Track tutorial progress
    Tutorial(\.tutorialState)
    
    Reduce { state, action in
        // Your feature logic
    }
    
    // Handle errors from any feature
    Prayer(
        listening: [\.child.failed],
        answerWith: { .handleError($0) }
    )
    
    // Track tutorial analytics
    Prayer(
        listening: [\.tutorialCompleted],
        answerWith: { .trackTutorialProgress }
    )
}
```

## Topics

### Prayer Reducer

Learn how to eliminate action forwarding boilerplate with Prayer.

- ``Prayer``
- ``PrayerUnit``
- <doc:Creating-Your-First-Prayer>
- <doc:Understanding-Prayer-Basics>
- <doc:Composing-Multiple-Prayers>
- <doc:Handling-Nested-Actions>
- <doc:Prayer-Code-Examples>

### Tutorial Reducer

Build interactive step-by-step tutorials and onboarding flows.

- ``Tutorial``
- ``TutorialState``
- ``TutorialInstruction``
- ``TutorialDetails``

### Related Documentation

- [The Composable Architecture](https://pointfreeco.github.io/swift-composable-architecture/)
- [Swift Case Paths](https://github.com/pointfreeco/swift-case-paths)
