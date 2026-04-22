//
//  Prayer.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 4/21/26.
//

import ComposableArchitecture

/**
 Prayer is a Reducer that listens to child of children.
 
 In an Action, user wants to have one action that will consume the prayers Children Actions will invoke
 ```swift
 enum Action {
    ...
    case handleError(String)
    ...
 }
 ```
 
 Parent would set up the Prayer reducer to listen to Specific Children Actions using CasePaths<ParentAction, MuzzinAction>
 ```swift
 Prayer(
     listening: [
         \.createTrainingCycleAction.presented.failedToSave,
         \.editPlanAction.presented.failedToSave
     ],
     answerWith: { errorMessage in
         .handleError(errorMessage)
     }
 )
 ```
 
 - Note: Inspiration came from Day of the Dead, a Mexican Tradition to honor Ancestors
 - Parameters:
    - listening: CasePath's to have the Reducer Listen (the prayers from descendants)
    - answerWith: Closure that transforms the prayer value into the parent action
 */
struct Prayer<ParentState, ParentAction: CasePathable, PrayerValue>: Reducer {
    
    let muezzins: [CaseKeyPath<ParentAction, PrayerValue>]
    let answer: (PrayerValue) -> ParentAction
    
    public init(
        listening muezzins: [CaseKeyPath<ParentAction, PrayerValue>],
        answerWith answer: @escaping (PrayerValue) -> ParentAction
    ) {
        self.muezzins = muezzins
        self.answer = answer
    }
    
    public func reduce(into state: inout ParentState, action: ParentAction) -> Effect<ParentAction> {
        // No prayers detected, continue normally
        return .concatenate(
            muezzins.compactMap { listenPrayer($0, action: action) }
                .map(answer)
                .map(EffectOf<Self>.send)
        )
    }
    
    func listenPrayer(_ muezzin: CaseKeyPath<ParentAction, PrayerValue>, action: ParentAction) -> PrayerValue? {
        return action[case: muezzin]
    }
}
