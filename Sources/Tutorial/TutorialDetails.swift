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
struct TutorialDetails: Equatable, Identifiable {
    init(_ displayID: CustomStringConvertible, _ detail: AttributedString) {
        @Dependency(\.uuid) var uuid
        self.displayID = displayID
        self.detail = detail
        self.id = uuid()
    }

    let detail: AttributedString
    let displayID: CustomStringConvertible
    let id: UUID
    
    
    static func == (lhs: TutorialDetails, rhs: TutorialDetails) -> Bool {
        lhs.id == rhs.id && lhs.displayID.description == rhs.displayID.description
    }
}

