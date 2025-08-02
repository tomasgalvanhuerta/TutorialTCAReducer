//
//  TutorialState.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/10/25.
//

import Foundation


/**
 To add more options, add an enum of options and Path's are a case

 ```swift
 enum TutorialStep {
 //  ##Future Work
    case path(Tutorial<ParentAction, Child>) //<---- Name to something better to describe action
    case description(String) // <--- New type Describing The sheet with information
    // Be nice to create something where movement can be displayed. like drag and drop
 }
 ```
 */
@available(macOS 14, *)
struct TutorialState<ParentAction: Equatable>: Equatable, Identifiable {
    typealias Path = TutorialInstruction<ParentAction>
    var steps: [Path]
    let title: String
    var displayID: String? {
        steps.first?.detail.displayID
    }
    var currentTutorialStep: Path? {
        steps.first
    }
    var id = UUID()
}
