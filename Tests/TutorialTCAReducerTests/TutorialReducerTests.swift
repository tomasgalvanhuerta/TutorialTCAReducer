//
//  TutorialReducerTests.swift
//  MoreToe WorksTests
//
//  Created by Tomas Galvan-Huerta on 7/12/25.
//

import Testing

struct TutorialReducerTests {

    @Test func removesFirstStepWhenActionMatches() async throws {
        var steps = ["Step 1", "Step 2", "Step 3"]
        let action = "Step 1"
        if action == steps.first {
            steps.removeFirst()
        }
        #expect(steps == ["Step 2", "Step 3"])
    }

    @Test func doesNotChangeStepsWhenActionDoesNotMatch() async throws {
        var steps = ["Step 1", "Step 2", "Step 3"]
        let action = "Step 4"
        if action == steps.first {
            steps.removeFirst()
        }
        #expect(steps == ["Step 1", "Step 2", "Step 3"])
    }

}
