//
//  TutorialDependencyTests 2.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//


import XCTest
import Testing
import Combine
import ComposableArchitecture


@testable import TutorialTCAReducer

struct TutorialDetailsTests {
    @Test
    func detail_intialize() async throws {
        let title = "TestIDTitle"
        let attructuredString = try AttributedString(markdown: "You are a wizard **Harry**")
        
        let uuid = UUID()

        withDependencies { dependencies in
            dependencies.uuid = .constant(uuid)
        } operation: {
            let details = TutorialDetails(title, attructuredString)
            #expect(details.displayID == title)
            #expect(details.id == uuid)
            #expect(details.detail == attructuredString)
        }
    }
}
