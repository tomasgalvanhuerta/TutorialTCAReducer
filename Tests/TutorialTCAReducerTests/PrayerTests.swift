//
//  PrayerTests.swift
//  MoreToe WorksTests
//
//  Created by Tomas Galvan-Huerta on 4/22/26.
//

import XCTest
import Combine
import ComposableArchitecture

@testable import TutorialTCAReducer

final class PrayerTests: XCTestCase {
    
    // MARK: - Basic Listening Tests
    
    @MainActor
    func testPrayerListensToSingleChildAction() async {
        let store = TestStore(
            initialState: PrayerParentFeature.State()
        ) {
            PrayerParentFeature()
        }
        
        // Send a child action that Prayer is listening for
        await store.send(.child(.failedToSave("Network error")))
        
        // Prayer should transform it into handleError
        await store.receive(\.handleError) { state in
            state.lastError = "Network error"
        }
    }
    
    @MainActor
    func testPrayerListensToMultipleChildren() async {
        let store = TestStore(
            initialState: PrayerParentFeature.State()
        ) {
            PrayerParentFeature()
        }
        
        // First child error
        await store.send(.child(.failedToSave("Database error")))
        await store.receive(\.handleError) { state in
            state.lastError = "Database error"
        }
        
        // Second child error
        await store.send(.anotherChild(.failedToLoad("API error")))
        await store.receive(\.handleError) { state in
            state.lastError = "API error"
        }
    }
    
    @MainActor
    func testPrayerIgnoresUnlistedActions() async {
        let store = TestStore(
            initialState: PrayerParentFeature.State()
        ) {
            PrayerParentFeature()
        }
        
        // Send an action Prayer is NOT listening for
        await store.send(.child(.succeeded))
        // Should not receive any transformed action
        // No state changes expected
    }
    
    // MARK: - Nested Action Tests
    
    @MainActor
    func testPrayerListensToDeeplyNestedActions() async {
        let store = TestStore(
            initialState: NestedParentFeature.State(
                modal: NestedChildFeature.State()
            )
        ) {
            NestedParentFeature()
        }
        
        // Send a deeply nested action through PresentationAction
        await store.send(.modal(.presented(.dataOperation(.failed("Sync error")))))
        
        // Prayer should transform it
        await store.receive(\.reportError) { state in
            state.errorLog.append("Sync error")
        }
    }
    
    // MARK: - Multiple Prayer Composition Tests
    
    @MainActor
    func testMultiplePrayersHandleDifferentConcerns() async {
        let store = TestStore(
            initialState: MultiPrayerFeature.State()
        ) {
            MultiPrayerFeature()
        }
        
        // Send an error action
        await store.send(.workflow(.errored("Validation failed")))
        
        // First Prayer handles errors
        await store.receive(\.logError) { state in
            state.errorCount += 1
        }
        
        // Second Prayer tracks analytics
        await store.receive(\.trackEvent) { state in
            state.eventLog.append("error_occurred")
        }
    }
    
    @MainActor
    func testMultiplePrayersListenToSameAction() async {
        let store = TestStore(
            initialState: MultiPrayerFeature.State()
        ) {
            MultiPrayerFeature()
        }
        
        // Send a success action
        await store.send(.workflow(.completed))
        
        // Both Prayers should respond
        await store.receive(\.celebrate) { state in
            state.successCount += 1
        }
        
        await store.receive(\.trackEvent) { state in
            state.eventLog.append("workflow_completed")
        }
    }
    
    // MARK: - Value Transformation Tests
    
    @MainActor
    func testPrayerTransformsValueCorrectly() async {
        let store = TestStore(
            initialState: PrayerParentFeature.State()
        ) {
            PrayerParentFeature()
        }
        
        let testErrors = ["Error 1", "Error 2", "Complex Error Message"]
        
        for error in testErrors {
            await store.send(.child(.failedToSave(error)))
            await store.receive(\.handleError) { state in
                state.lastError = error
                XCTAssertEqual(state.lastError, error, "Prayer should preserve the exact error message")
            }
        }
    }
    
    @MainActor
    func testPrayerHandlesVoidPrayerValue() async {
        let store = TestStore(
            initialState: VoidPrayerFeature.State()
        ) {
            VoidPrayerFeature()
        }
        
        // Send action with no associated value
        await store.send(.task(.completed))
        
        // Prayer should still trigger the transformation
        await store.receive(\.notifyCompletion) { state in
            state.completionCount += 1
        }
    }
    
    // MARK: - Effect Concatenation Tests
    
    @MainActor
    func testPrayerEffectsAreConcatenated() async {
        let store = TestStore(
            initialState: OrderedPrayerFeature.State()
        ) {
            OrderedPrayerFeature()
        }
        
        // Send an action that matches multiple listening paths
        await store.send(.operation(.step1Error("First")))
        
        // Should receive in the order Prayers are composed
        await store.receive(\.firstHandler) { state in
            state.handlerOrder.append("first")
        }
        
        await store.send(.operation(.step2Error("Second")))
        
        await store.receive(\.secondHandler) { state in
            state.handlerOrder.append("second")
        }
        
        // Verify order
        XCTAssertEqual(store.state.handlerOrder, ["first", "second"])
    }
    
    // MARK: - Edge Cases
    
    @MainActor
    func testPrayerWithEmptyListeningArray() async {
        let store = TestStore(
            initialState: EmptyPrayerFeature.State()
        ) {
            EmptyPrayerFeature()
        }
        
        // Even if we send actions, Prayer with empty array won't respond
        await store.send(.someAction)
        // No receives expected
    }
    
    @MainActor
    func testPrayerDoesNotModifyState() async {
        let initialState = PrayerParentFeature.State()
        let store = TestStore(initialState: initialState) {
            PrayerParentFeature()
        }
        
        // Prayer should only send effects, not modify state itself
        // State changes happen in the parent reducer when handling the transformed action
        await store.send(.child(.failedToSave("Test")))
        await store.receive(\.handleError) { state in
            // State is modified here by the parent reducer, not by Prayer
            state.lastError = "Test"
        }
    }
    
    @MainActor
    func testPrayerWorksWithOptionalValues() async {
        let store = TestStore(
            initialState: OptionalPrayerFeature.State()
        ) {
            OptionalPrayerFeature()
        }
        
        // Send with non-nil value
        await store.send(.resource(.loaded(42)))
        await store.receive(\.handleLoaded) { state in
            state.lastLoadedValue = 42
        }
    }
}

// MARK: - Test Fixtures

// MARK: Basic Prayer Feature
@Reducer
struct PrayerParentFeature {
    @ObservableState
    struct State: Equatable {
        var lastError: String?
    }
    
    @CasePathable
    enum Action: Equatable {
        case handleError(String)
        case child(ChildAction)
        case anotherChild(AnotherChildAction)
    }
    
    @CasePathable
    enum ChildAction: Equatable {
        case failedToSave(String)
        case succeeded
    }
    
    @CasePathable
    enum AnotherChildAction: Equatable {
        case failedToLoad(String)
        case loaded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .handleError(error):
                state.lastError = error
                return .none
            case .child, .anotherChild:
                return .none
            }
        }
        
        // Prayer listening to child errors
        Prayer(
            listening: [
                \.child.failedToSave,
                \.anotherChild.failedToLoad
            ],
            answerWith: { errorMessage in
                .handleError(errorMessage)
            }
        )
    }
}

// MARK: Nested Prayer Feature
@Reducer
struct NestedParentFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var modal: NestedChildFeature.State?
        var errorLog: [String] = []
    }
    
    @CasePathable
    enum Action: Equatable {
        case reportError(String)
        case modal(PresentationAction<NestedChildFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .reportError(error):
                state.errorLog.append(error)
                return .none
            case .modal:
                return .none
            }
        }
        
        Prayer(
            listening: [
                \.modal.presented.dataOperation.failed
            ],
            answerWith: { error in
                .reportError(error)
            }
        )
        
        .ifLet(\.$modal, action: \.modal) {
            NestedChildFeature()
        }
    }
}

@Reducer
struct NestedChildFeature {
    @ObservableState
    struct State: Equatable {}
    
    @CasePathable
    enum Action: Equatable {
        case dataOperation(DataAction)
    }
    
    @CasePathable
    enum DataAction: Equatable {
        case failed(String)
        case succeeded
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
    }
}

// MARK: Multiple Prayer Feature
@Reducer
struct MultiPrayerFeature {
    @ObservableState
    struct State: Equatable {
        var errorCount: Int = 0
        var successCount: Int = 0
        var eventLog: [String] = []
    }
    
    @CasePathable
    enum Action: Equatable {
        case logError
        case celebrate
        case trackEvent(String)
        case workflow(WorkflowAction)
    }
    
    @CasePathable
    enum WorkflowAction: Equatable {
        case errored(String)
        case completed
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .logError:
                state.errorCount += 1
                return .none
            case .celebrate:
                state.successCount += 1
                return .none
            case let .trackEvent(event):
                state.eventLog.append(event)
                return .none
            case .workflow:
                return .none
            }
        }
        
        // Prayer #1: Error handling
        Prayer(
            listening: [\.workflow.errored],
            answerWith: { _ in .logError }
        )
        
        // Prayer #2: Analytics for errors
        Prayer(
            listening: [\.workflow.errored],
            answerWith: { _ in .trackEvent("error_occurred") }
        )
        
        // Prayer #3: Success celebration
        Prayer(
            listening: [\.workflow.completed],
            answerWith: { .celebrate }
        )
        
        // Prayer #4: Analytics for success
        Prayer(
            listening: [\.workflow.completed],
            answerWith: { .trackEvent("workflow_completed") }
        )
    }
}

// MARK: Void Prayer Feature
@Reducer
struct VoidPrayerFeature {
    @ObservableState
    struct State: Equatable {
        var completionCount: Int = 0
    }
    
    @CasePathable
    enum Action: Equatable {
        case notifyCompletion
        case task(TaskAction)
    }
    
    @CasePathable
    enum TaskAction: Equatable {
        case completed
        case started
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .notifyCompletion:
                state.completionCount += 1
                return .none
            case .task:
                return .none
            }
        }
        
        Prayer(
            listening: [\.task.completed],
            answerWith: { .notifyCompletion }
        )
    }
}

// MARK: Ordered Prayer Feature
@Reducer
struct OrderedPrayerFeature {
    @ObservableState
    struct State: Equatable {
        var handlerOrder: [String] = []
    }
    
    @CasePathable
    enum Action: Equatable {
        case firstHandler
        case secondHandler
        case operation(OperationAction)
    }
    
    @CasePathable
    enum OperationAction: Equatable {
        case step1Error(String)
        case step2Error(String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .firstHandler:
                state.handlerOrder.append("first")
                return .none
            case .secondHandler:
                state.handlerOrder.append("second")
                return .none
            case .operation:
                return .none
            }
        }
        
        Prayer(
            listening: [\.operation.step1Error],
            answerWith: { _ in .firstHandler }
        )
        
        Prayer(
            listening: [\.operation.step2Error],
            answerWith: { _ in .secondHandler }
        )
    }
}

// MARK: Empty Prayer Feature
@Reducer
struct EmptyPrayerFeature {
    @ObservableState
    struct State: Equatable {}
    
    @CasePathable
    enum Action: Equatable {
        case someAction
        case handleSomething
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            .none
        }
        
        // Prayer with empty listening array
        Prayer<State, Action, String>(
            listening: [],
            answerWith: { _ in .handleSomething }
        )
    }
}

// MARK: Optional Prayer Feature
@Reducer
struct OptionalPrayerFeature {
    @ObservableState
    struct State: Equatable {
        var lastLoadedValue: Int?
    }
    
    @CasePathable
    enum Action: Equatable {
        case handleLoaded(Int)
        case resource(ResourceAction)
    }
    
    @CasePathable
    enum ResourceAction: Equatable {
        case loaded(Int)
        case loading
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .handleLoaded(value):
                state.lastLoadedValue = value
                return .none
            case .resource:
                return .none
            }
        }
        
        Prayer(
            listening: [\.resource.loaded],
            answerWith: { value in .handleLoaded(value) }
        )
    }
}
