# ``TutorialTCAReducer``

Learn how to use the Prayer reducer pattern to handle cross-cutting concerns in your Composable Architecture applications.

## Overview

TutorialTCAReducer introduces the **Prayer** pattern, a powerful reducer composition technique that allows parent features to listen to deeply nested child actions and respond with their own actions. This pattern is particularly useful for handling cross-cutting concerns like error handling, analytics, logging, and side effect coordination.

Think of Prayer as a "listener" that watches for specific actions from child features and automatically transforms them into parent actions, without requiring explicit action forwarding through every level of your feature hierarchy.

### Why Use Prayer?

In traditional TCA, handling child actions in parent reducers requires explicit action forwarding:

```swift
case .child(.failedToSave(let error)):
    state.errorMessage = error
    return .none
```

With Prayer, you declare what to listen for once, and it handles the rest:

```swift
Prayer(
    listening: [\.child.failedToSave],
    answerWith: { error in .handleError(error) }
)
```

## Topics

### Essentials

- <doc:Prayer>
- <doc:PrayerUnit>

### Tutorials

- <doc:TutorialTCAReducer>

### Articles

- <doc:Prayer-Code-Examples>
