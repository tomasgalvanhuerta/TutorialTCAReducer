//
//  TutorialReducerTests.swift
//  MoreToe WorksTests
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//

import Testing
import XCTest
import Combine
import ComposableArchitecture

@testable import TutorialTCAReducer

struct TutorialReducerTests {

    @MainActor
    @Test func removesFirstStepWhenActionMatchesOneAction() async throws {
        // Not meant to stop Tutorial because there is another action, `action2` next
        let title = "TestTitle How to become a witch"
        
        await withDependencies { dependency in
            dependency.uuid = .incrementing
        } operation: {
            let paths: [TutorialState<MockParentDomain.Action>.Path] = [
                .init(detail: .init("Test", .init("AttributeString")), path: .action1),
                .init(detail: .init("Test", .init("AttributeString")), path: .action2)
            ]
            let parentState = MockParentDomain.State.init(tutorialState: .init(steps: paths, title: title))
            
            let pathExpectation = XCTestExpectation(description: "Should a path")
            let channel = TestChannel(pathExpectation: pathExpectation)
            let store = TestStore(initialState: parentState, reducer: MockParentDomain.init) { dependency in
                dependency.tutorial = channel
            }
            
            await store.send(.action1) { state in
                state.tutorialState.steps = [paths[1]]
            }
            
            await XCTWaiter.fulfillment(of: [pathExpectation], timeout: 1.0)
        }
    }
    
    @MainActor
    @Test func removesFirstStepWhenActionMatchesAllActions() async throws {
        // Not meant to stop Tutorial because there is another action, `action2` next
        let title = "TestTitle How to become a witch"
        
        await withDependencies { dependency in
            dependency.uuid = .incrementing
        } operation: {
            let paths: [TutorialState<MockParentDomain.Action>.Path] = [
                .init(detail: .init("Test", .init("AttributeString")), path: .action1),
                .init(detail: .init("Test", .init("AttributeString")), path: .action2)
            ]
            let parentState = MockParentDomain.State.init(tutorialState: .init(steps: paths, title: title))
            
            let pathExpectation = XCTestExpectation(description: "Should a path")
            let stopExpectation = XCTestExpectation(description: "Stop Tutorial should kick")
            let channel = TestChannel(first: pathExpectation, second: stopExpectation)
            let store = TestStore(initialState: parentState, reducer: MockParentDomain.init) { dependency in
                dependency.tutorial = channel
            }
            
            await store.send(.action1) { state in
                state.tutorialState.steps = [paths[1]]
            }
            
            await store.send(.action2) { state in
                state.tutorialState.steps = []
            }
            
            await XCTWaiter.fulfillment(of: [pathExpectation, stopExpectation], timeout: 1.0)
        }
    }

    @Test func doesNotChangeStepsWhenActionDoesNotMatch() async throws {
        // Not meant to stop Tutorial because there is another action, `action2` next
        let title = "TestTitle How to become a witch"
        
        await withDependencies { dependency in
            dependency.uuid = .incrementing
        } operation: {
            let paths: [TutorialState<MockParentDomain.Action>.Path] = [
                .init(detail: .init("Test", .init("AttributeString")), path: .action3),
                .init(detail: .init("Test", .init("AttributeString")), path: .action2)
            ]
            let parentState = MockParentDomain.State.init(tutorialState: .init(steps: paths, title: title))
            
            let pathExpectation = XCTestExpectation(description: "Should a path")
            let channel = TestChannel(pathExpectation: pathExpectation)
            let store = await TestStore(initialState: parentState, reducer: MockParentDomain.init) { dependency in
                dependency.tutorial = channel
            }
            
            await store.send(.action1)
        }
    }
    
    @Test func doesNotChangeStepsWhenActionDoesNotMatch_OutOfOrder() async throws {
        // Not meant to stop Tutorial because there is another action, `action2` next
        let title = "TestTitle How to become a witch"
        
        await withDependencies { dependency in
            dependency.uuid = .incrementing
        } operation: {
            let paths: [TutorialState<MockParentDomain.Action>.Path] = [
                .init(detail: .init("Test", .init("AttributeString")), path: .action3),
                .init(detail: .init("Test", .init("AttributeString")), path: .action2)
            ]
            let parentState = MockParentDomain.State.init(tutorialState: .init(steps: paths, title: title))
            
            let pathExpectation = XCTestExpectation(description: "Should a path")
            let channel = TestChannel(pathExpectation: pathExpectation)
            let store = await TestStore(initialState: parentState, reducer: MockParentDomain.init) { dependency in
                dependency.tutorial = channel
            }
            
            await store.send(.action2)
        }
    }

}

struct TestChannel: TutorialChannel {
    let pathExpectation: XCTestExpectation?
    let stopTutorialExpectation: XCTestExpectation?
    
    func path(_ path: TutorialDetails?) {
        guard let pathExpectation else { return XCTFail("Did not expect to recieve a path") }
        pathExpectation.fulfill()
    }
    
    func stopTutorial() {
        guard let stopTutorialExpectation else { return XCTFail("Did not expect to stop tutorial") }
        stopTutorialExpectation.fulfill()
    }
    
    init(pathExpectation: XCTestExpectation) {
        self.pathExpectation = pathExpectation
        self.stopTutorialExpectation = nil
    }
    
    init(stopTutorialExpectation: XCTestExpectation) {
        self.stopTutorialExpectation = stopTutorialExpectation
        self.pathExpectation = nil
    }
    
    init(first pathExpectation: XCTestExpectation, second stopTutorialExpectation: XCTestExpectation) {
        self.pathExpectation = pathExpectation
        self.stopTutorialExpectation = stopTutorialExpectation
    }
    
    var publisher: AnyPublisher<TutorialDetails?, Never> {
        Empty().eraseToAnyPublisher()
    }
    
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> {
        Empty().eraseToAnyPublisher()
    }
}


@Reducer
struct MockParentDomain: Reducer {
    @ObservableState
    struct State: Equatable {
        var tutorialState = TutorialState<MockParentDomain.Action>(steps: [], title: "")
    }
    @CasePathable
    enum Action: Equatable {
        case initialize
        case action1
        case action2
        case action3
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .none
            case .action1:
                return .none
            case .action2:
                return .none
            case .action3:
                return .none
            }
        }
        Tutorial(\.tutorialState)
    }
}

