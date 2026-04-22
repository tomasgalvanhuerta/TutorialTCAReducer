# Prayer Code Examples

Common patterns and real-world examples of using Prayer reducers in your TCA applications.

## Basic Error Handling

Handle errors from multiple child features in one place:

```swift
@Reducer
struct AppFeature {
    @ObservableState
    struct State: Equatable {
        var errorMessage: String?
        var profileState = ProfileFeature.State()
        var settingsState = SettingsFeature.State()
    }
    
    @CasePathable
    enum Action: Equatable {
        case handleError(String)
        case profile(ProfileFeature.Action)
        case settings(SettingsFeature.Action)
        case dismissError
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.profileState, action: \.profile) {
            ProfileFeature()
        }
        
        Scope(state: \.settingsState, action: \.settings) {
            SettingsFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .handleError(message):
                state.errorMessage = message
                return .none
                
            case .dismissError:
                state.errorMessage = nil
                return .none
                
            case .profile, .settings:
                return .none
            }
        }
        
        // Prayer listens to all error actions
        Prayer(
            listening: [
                \.profile.failedToSave,
                \.profile.failedToLoad,
                \.settings.failedToUpdate
            ],
            answerWith: { error in
                .handleError(error)
            }
        )
    }
}
```

## Analytics Tracking

Automatically track analytics events from anywhere in your app:

```swift
@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var analyticsEvents: [String] = []
        // ... child states
    }
    
    @CasePathable
    enum Action: Equatable {
        case trackAnalytics(String)
        case user(UserFeature.Action)
        case content(ContentFeature.Action)
    }
    
    @Dependency(\.analytics) var analytics
    
    var body: some ReducerOf<Self> {
        // ... child reducers
        
        Reduce { state, action in
            switch action {
            case let .trackAnalytics(event):
                state.analyticsEvents.append(event)
                return .run { _ in
                    await analytics.track(event)
                }
                
            default:
                return .none
            }
        }
        
        // Track user actions
        Prayer(
            listening: [
                \.user.loggedIn,
                \.user.loggedOut,
                \.user.profileUpdated
            ],
            answerWith: { .trackAnalytics("user_action") }
        )
        
        // Track content interactions
        Prayer(
            listening: [
                \.content.itemViewed,
                \.content.itemShared
            ],
            answerWith: { .trackAnalytics("content_interaction") }
        )
    }
}
```

## Side Effect Coordination

Trigger side effects when specific child actions occur:

```swift
@Reducer
struct DataSyncFeature {
    @ObservableState
    struct State: Equatable {
        var lastSyncTime: Date?
        var localData = LocalDataFeature.State()
        var remoteData = RemoteDataFeature.State()
    }
    
    @CasePathable
    enum Action: Equatable {
        case syncToCloud
        case local(LocalDataFeature.Action)
        case remote(RemoteDataFeature.Action)
    }
    
    @Dependency(\.cloudSync) var cloudSync
    
    var body: some ReducerOf<Self> {
        // ... child reducers
        
        Reduce { state, action in
            switch action {
            case .syncToCloud:
                state.lastSyncTime = Date()
                return .run { [state] _ in
                    await cloudSync.upload(state.localData)
                }
                
            default:
                return .none
            }
        }
        
        // Auto-sync when local data changes
        Prayer(
            listening: [
                \.local.dataUpdated,
                \.local.dataCreated,
                \.local.dataDeleted
            ],
            answerWith: { .syncToCloud }
        )
    }
}
```

## Cross-Feature Communication

Enable features to react to each other without tight coupling:

```swift
@Reducer
struct ShoppingCartFeature {
    @ObservableState
    struct State: Equatable {
        var itemCount: Int = 0
        var catalog = CatalogFeature.State()
        var checkout = CheckoutFeature.State()
    }
    
    @CasePathable
    enum Action: Equatable {
        case itemAdded
        case itemRemoved
        case updateBadge
        case catalog(CatalogFeature.Action)
        case checkout(CheckoutFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        // ... child reducers
        
        Reduce { state, action in
            switch action {
            case .itemAdded:
                state.itemCount += 1
                return .none
                
            case .itemRemoved:
                state.itemCount -= 1
                return .none
                
            case .updateBadge:
                // Update UI badge
                return .none
                
            default:
                return .none
            }
        }
        
        // Listen to catalog actions
        Prayer(
            listening: [\.catalog.addToCart],
            answerWith: { .itemAdded }
        )
        
        // Listen to checkout actions
        Prayer(
            listening: [\.checkout.purchaseCompleted],
            answerWith: { .itemRemoved }
        )
        
        // Update badge on any cart change
        Prayer(
            listening: [
                \.itemAdded,
                \.itemRemoved
            ],
            answerWith: { .updateBadge }
        )
    }
}
```

## Void Actions (No Associated Values)

Handle actions that don't carry data:

```swift
@Reducer
struct NotificationFeature {
    @ObservableState
    struct State: Equatable {
        var notificationCount: Int = 0
        var messages = MessageFeature.State()
        var alerts = AlertFeature.State()
    }
    
    @CasePathable
    enum Action: Equatable {
        case incrementBadge
        case messages(MessageFeature.Action)
        case alerts(AlertFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        // ... child reducers
        
        Reduce { state, action in
            switch action {
            case .incrementBadge:
                state.notificationCount += 1
                return .none
                
            default:
                return .none
            }
        }
        
        // Listen to Void actions (no associated values)
        Prayer(
            listening: [
                \.messages.received,
                \.alerts.triggered
            ],
            answerWith: { .incrementBadge }
        )
    }
}
```

## Deeply Nested Actions

Listen to actions through multiple presentation layers:

```swift
@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var errorLog: [String] = []
        @Presents var settings: SettingsFeature.State?
    }
    
    @CasePathable
    enum Action: Equatable {
        case logError(String)
        case settings(PresentationAction<SettingsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .logError(error):
                state.errorLog.append(error)
                return .none
                
            case .settings:
                return .none
            }
        }
        
        // Listen through PresentationAction to nested child actions
        Prayer(
            listening: [
                \.settings.presented.account.presented.deleteAccount.failed,
                \.settings.presented.privacy.presented.dataExport.failed
            ],
            answerWith: { error in
                .logError(error)
            }
        )
        
        .ifLet(\.$settings, action: \.settings) {
            SettingsFeature()
        }
    }
}
```

## Best Practices

### 1. Keep Prayer Reducers Focused

Each Prayer should handle one concern:

```swift
// ✅ Good: Separate Prayers for different concerns
Prayer(listening: [\.child.failed], answerWith: { .logError($0) })
Prayer(listening: [\.child.succeeded], answerWith: { .trackSuccess })

// ❌ Avoid: One Prayer doing too much
Prayer(
    listening: [\.child.failed, \.child.succeeded],
    answerWith: { /* complex logic */ }
)
```

### 2. Compose Multiple Prayers

Use multiple Prayers for different aspects of the same actions:

```swift
// Error logging
Prayer(listening: [\.operation.failed], answerWith: { .logError($0) })

// Analytics
Prayer(listening: [\.operation.failed], answerWith: { .trackEvent("error") })

// User notification
Prayer(listening: [\.operation.failed], answerWith: { .showAlert($0) })
```

### 3. Order Matters

Prayers execute in composition order:

```swift
// Critical operations first
Prayer(listening: [\.data.corrupted], answerWith: { .emergencyBackup })
Prayer(listening: [\.data.corrupted], answerWith: { .logCriticalError })
Prayer(listening: [\.data.corrupted], answerWith: { .notifyUser })
```

## See Also

- <doc:Understanding-Prayer-Basics>
- <doc:Composing-Multiple-Prayers>
- <doc:Handling-Nested-Actions>
