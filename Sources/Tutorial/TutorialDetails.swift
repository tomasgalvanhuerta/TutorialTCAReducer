//
//  TutorialDetails.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/10/25.
//


import SwiftUI
import Dependencies
/**
    Details that will be presented as a popOver
 
 */
@available(macOS 12, *)
struct TutorialDetails: Equatable, Identifiable, Sendable {
    @available(macOS 12, *)
    init(_ displayID: String, _ detail: AttributedString) {
        @Dependency(\.uuid) var uuid
        self.displayID = displayID
        self.detail = detail
        self.id = uuid()
    }

    let detail: AttributedString
    let displayID: String
    let id: UUID
}
