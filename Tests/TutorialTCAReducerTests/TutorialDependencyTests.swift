//
//  TutorialDependencyTests.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//


import XCTest
import Testing
import Combine
import Dependencies

@testable import TutorialTCAReducer

struct TutorialDependencyTests {

    @Test func path_emitsNewValue() async throws {
        let tutorial: TutorialDependency = .init()
        var cancellables: Set<AnyCancellable> = []
        let uuid = UUID()
        await withDependencies { dependency in
            dependency.uuid = .constant(uuid)
        } operation: {
            let expectedString = AttributedString("Testing String")
            let title: String = "Testing Title"
            let expected = TutorialDetails(title, expectedString)
            let expectation = XCTestExpectation(description: "Should publish new tutorial step")

            tutorial.publisher
                .dropFirst() // drop the initial nil
                .sink { tutorialDetails in
                    #expect(tutorialDetails?.detail == expected.detail)
                    expectation.fulfill()
                }
                .store(in: &cancellables)

            tutorial.path(expected)

            _ = await XCTWaiter.fulfillment(of: [expectation], timeout: 1.0)
        }
    }

    @Test func path_nil_callsStopTutorial() async throws {
        let tutorial: TutorialDependency = .init()
        var cancellables: Set<AnyCancellable> = []
        let uuid = UUID()
        await withDependencies { dependency in
            dependency.uuid = .constant(uuid)
        } operation: {
            let expectedString = AttributedString("Testing String")
            let title: String = "Testing Title"
            let expected = TutorialDetails(title, expectedString)
            let expectation = XCTestExpectation(description: "Should emit on cancel")
            
            tutorial.path(expected)
            
            tutorial.cancelCurrent
                .sink { value in
                    #expect(value == expected)
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            tutorial.path(nil)
            
            _ = await XCTWaiter.fulfillment(of: [expectation], timeout: 1.0)
        }
    }

    @Test func stopTutorial_resetsRelay() async throws {
        let tutorial = TutorialDependency()
        var cancellables: Set<AnyCancellable> = []
        let expectCancel = XCTestExpectation(description: "Should emit on cancel")
        let expectNil = XCTestExpectation(description: "Should emit nil")
        
        tutorial.publisher
            .sink { value in
                XCTAssertNil(value)
                expectNil.fulfill()
            }.store(in: &cancellables)
        
        tutorial.cancelCurrent
            .sink { value in
                XCTAssertNil(value)
                expectCancel.fulfill()
            }
            .store(in: &cancellables)
        
        tutorial.stopTutorial()
        _ = await XCTWaiter.fulfillment(of: [expectCancel, expectNil], timeout: 1.0)
    }
}
