//
//  TutorialReducer.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 6/20/25.
//

import Foundation
import ComposableArchitecture
import CasePaths

/**
 Tutorial is intended to  be provided ParentActions and compare if the action has been executed.
 The executed actions will be removed from the required steps
 If the steps are interrupted, user should restart the process
 
 Example how to create TutorialState
 ```swift
 let homeTocreatePlan: () -> TutorialState<TabBarDomain.Action> = {
     let title = "Create Plan"
     
     let paths: [TutorialPath<TabBarDomain.Action>] = [
         .init(displayID: HomeTutorialExample.customizePlanButton.rawValue, path: .homeDetailNavigation(.userInteraction(.tappedEditPlanButton))),
         .init(displayID: HomeTutorialExample.newPlanButton.rawValue, path: .homeDetailNavigation(.detail(.planAction(.presentNewPlan)))),
         .init(displayID: HomeTutorialExample.nextEditTitle.rawValue, path: .homeDetailNavigation(.detail(.planAction(.createPlanAction(.presented(.nextEdit)))))),
         .init(displayID: HomeTutorialExample.nextEditTitle.rawValue, path: .homeDetailNavigation(.detail(.planAction(.createPlanAction(.presented(.nextEdit))))))
         
     ]
     return .init(steps: paths, title: title)
 }

 enum HomeTutorialExample: String {
     case customizePlanButton
     case newPlanButton
     case cancelPlan
     case nextEditTitle
     case nextEditSubtitle
 }
 ```
 */
struct Tutorial<ParentState, ParentAction: Equatable>: Reducer {
    @Dependency(\.tutorial) var tutorial

    typealias ChildState = TutorialState<ParentAction>
    let toChildState: WritableKeyPath<ParentState, ChildState>

    public init(
        _ state: WritableKeyPath<ParentState, ChildState>, // Writable Keypath this
    ) {
        self.toChildState = state
    }
    
    public func reduce(
        into state: inout ParentState,
        action: ParentAction
      ) -> Effect<ParentAction> {
          if action == state[keyPath: toChildState].currentTutorialStep?.path {
              state[keyPath: toChildState].steps.removeFirst()
              tutorial.path(state[keyPath: toChildState].steps.first?.detail)
          }
          return .none
      }
}



/**
 Path represents the action user will tap.
 - TODO:
    - There is no way for the associated value to be reconstructed from The expected path.
 */
struct TutorialInstruction<ParentAction: Equatable>: Equatable {
    let detail: TutorialDetails
    let path: ParentAction
}
