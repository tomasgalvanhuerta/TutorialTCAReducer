//
//  TutorialDependencyTests.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//


import XCTest
import Combine
@testable import MoreToe_Works

final class TutorialDependencyTests: XCTestCase {
    var tutorial: TutorialDependency!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        tutorial = TutorialDependency()
        cancellables = []
    }

    override func tearDown() {
        tutorial = nil
        cancellables = nil
        super.tearDown()
    }

    func test_path_emitsNewValue() {
        let expected = TutorialDetails(id: "intro", step: 1)
        let expectation = XCTestExpectation(description: "Should publish new tutorial step")

        tutorial.publisher
            .dropFirst() // drop the initial nil
            .sink { value in
                XCTAssertEqual(value?.id, expected.id)
                XCTAssertEqual(value?.step, expected.step)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.path(expected)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_path_nil_callsStopTutorial() {
        let expected = TutorialDetails(id: "exit", step: 99)
        let expectation = XCTestExpectation(description: "Should emit on cancel")

        tutorial.path(expected)

        tutorial.cancelCurrent
            .sink { value in
                XCTAssertEqual(value?.id, expected.id)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.path(nil)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_stopTutorial_resetsRelay() {
        let expected = TutorialDetails(id: "stop", step: 0)
        let cancelExpectation = XCTestExpectation(description: "Cancel should emit previous value")
        let clearExpectation = XCTestExpectation(description: "Publisher should emit nil")

        tutorial.path(expected)

        tutorial.cancelCurrent
            .sink { value in
                XCTAssertEqual(value?.id, expected.id)
                cancelExpectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.publisher
            .dropFirst(2) // initial nil, then value
            .sink { value in
                XCTAssertNil(value)
                clearExpectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.stopTutorial()

        wait(for: [cancelExpectation, clearExpectation], timeout: 1.0)
    }
}
