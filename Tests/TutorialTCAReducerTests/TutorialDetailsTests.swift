//
//  TutorialDependencyTests 2.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//


import XCTest
import Combine
import ComposableArchitecture


@testable import TutorialTCAReducer

final class TutorialDetailsTests: XCTestCase {
    
    @MainActor
    func testDetailIntialize() async throws {
        let title = "TestIDTitle"
        let attructuredString = try AttributedString(markdown: "You are a wizard **Harry**")
        
        let uuid = UUID()

        await withDependencies { dependencies in
            dependencies.uuid = .constant(uuid)
        } operation: {
            let details = TutorialDetails(title, attructuredString)
            XCTAssertEqual(details.displayID, title)
            XCTAssertEqual(details.id, uuid)
            XCTAssertEqual(details.detail, attructuredString)
        }
    }
}
