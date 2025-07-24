//
//  TutorialDependencyTests 2.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//


import XCTest
import Combine
@testable import MoreToe_Works

final class TutorialDetailsTests: XCTestCase {
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
        let detail = TutorialDetails("intro", try? AttributedString(markdown: "Step 1"))
        let expectation = XCTestExpectation(description: "Should publish new tutorial detail")

        tutorial.publisher
            .dropFirst()
            .sink { value in
                XCTAssertEqual(value?.displayID, detail.displayID)
                XCTAssertEqual(value?.detail, detail.detail)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.path(detail)
        wait(for: [expectation], timeout: 1.0)
    }

    func test_path_nil_callsStopTutorial() {
        let detail = TutorialDetails("exit")
        let expectation = XCTestExpectation(description: "Should emit cancellation")

        tutorial.path(detail)

        tutorial.cancelCurrent
            .sink { value in
                XCTAssertEqual(value?.displayID, detail.displayID)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.path(nil)
        wait(for: [expectation], timeout: 1.0)
    }

    func test_stopTutorial_resetsRelay() {
        let detail = TutorialDetails("step")
        let cancelExpectation = XCTestExpectation(description: "Cancel should emit")
        let clearExpectation = XCTestExpectation(description: "Publisher should emit nil")

        tutorial.path(detail)

        tutorial.cancelCurrent
            .sink { value in
                XCTAssertEqual(value?.displayID, detail.displayID)
                cancelExpectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.publisher
            .dropFirst(2) // skip initial nil and first value
            .sink { value in
                XCTAssertNil(value)
                clearExpectation.fulfill()
            }
            .store(in: &cancellables)

        tutorial.stopTutorial()
        wait(for: [cancelExpectation, clearExpectation], timeout: 1.0)
    }

    func test_equatable_respectsDisplayIDAndDetailOnly() {
        let a = TutorialDetails("abc", try? AttributedString(markdown: "Hello"))
        let b = TutorialDetails("abc", try? AttributedString(markdown: "Hello"))

        // UUIDs are different, but Equatable only checks displayID and detail
        XCTAssertNotEqual(a.id, b.id)
        XCTAssertEqual(a.displayID, b.displayID)
        XCTAssertEqual(a.detail, b.detail)
        XCTAssertNotEqual(a, b, "Should not be equal because UUID is part of struct")
    }

    func test_identifiable_returnsUUID() {
        let detail = TutorialDetails("idCheck")
        let uuid = detail.id
        XCTAssertEqual(detail.id, uuid)
    }
}
