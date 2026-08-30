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
struct TutorialState<ParentAction: Equatable>: Equatable, Identifiable {
    typealias Path = TutorialInstruction<ParentAction>
    var steps: [Path]
    let title: String
    var displayID: String? {
        steps.first?.detail.displayID.description
    }
    var currentTutorialStep: Path? {
        steps.first
    }
    var id = UUID()
}

extension TutorialState {
    /// Add Steps to existing TutorialState by combing TutorialState
    /// Title and ID will stay the same
    /// User would need to convert from The child Action to parent action
    func addFrom(_ tutorialState: TutorialState) -> TutorialState<ParentAction> {
        var newTutorialState = self
        newTutorialState.steps.append(contentsOf: tutorialState.steps)
        return newTutorialState
    }
    
//    // RepCellDomain -> ActiveNavigationDomain.Action
//    /// Transforms the TutorialState Child Path's to Parent Paths
//    func path<T: Equatable, Y: Equatable>(_ transform: @escaping (([T]) -> Y)) -> [TutorialInstruction<Y>] {
//
//    }
}

/**
 Get TutorialState
    - let tutorial = SomeDomain.TutorialToPerformState()
 Transform Child Actions to Parent Actions
    - let transformedSteps = tutorialstate.steps.map(ParentActoin)
    
 Turn to Tutorial State
    - let readyTutorialState = TutorialState.init( title: "Name of new TutorialState", paths: [transformedSteps])
 
 
 Create Initializer for ParentAction <---- Can we Make this a generic initializer? No.....
  
 */
