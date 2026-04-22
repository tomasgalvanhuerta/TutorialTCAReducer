# ``TutorialTCAReducer``

Learn how to use the Prayer reducer pattern to handle cross-cutting concerns in your Composable Architecture applications.

## Overview

TutorialTCAReducer introduces the **Prayer** pattern, a powerful reducer composition technique that allows parent features to listen to deeply nested child actions and respond with their own actions. This pattern is particularly useful for handling cross-cutting concerns like error handling, analytics, logging, and side effect coordination.

Think of Prayer as a "listener" that watches for specific actions from child features and automatically transforms them into parent actions, without requiring explicit action forwarding through every level of your feature hierarchy.

## Topics

### Getting Started

- <doc:Creating-Your-First-Prayer>
- <doc:Understanding-Prayer-Basics>
### Advanced Techniques

- <doc:Composing-Multiple-Prayers>
- <doc:Handling-Nested-Actions>

### API Reference

- ``Prayer``
- ``PrayerUnit``

### Sample Code

- <doc:Prayer-Code-Examples>
