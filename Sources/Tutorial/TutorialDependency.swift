//
//  TutorialDependency.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/7/25.
//

import Foundation
import Combine
import Dependencies

protocol TutorialChannel {
    func path(_ path: TutorialDetails?)
    func stopTutorial()
    
    /// Publishes next tutorial step if applicable
    var publisher: AnyPublisher<TutorialDetails?, Never> { get }
    /// Sends the last details before canceled
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> { get }
}

final class TutorialDependency: TutorialChannel {
    typealias Input = TutorialDetails
    typealias Failure = Never
    init() { }
    let relay: CurrentValueSubject<TutorialDetails?, Never> = .init(nil)
    let cancelRelay: PassthroughSubject<TutorialDetails?, Never> = .init()
    
    var publisher: AnyPublisher<TutorialDetails?, Never> { relay.eraseToAnyPublisher() }
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> { cancelRelay.eraseToAnyPublisher() }

    func path(_ path: TutorialDetails?) {
        if let path {
            relay.send(path)
        } else {
            stopTutorial()
        }
    }

    func stopTutorial() {
        cancelRelay.send(relay.value)
        relay.send(nil)
        
    }
}

extension TutorialDependency: DependencyKey {
    static var liveValue: TutorialChannel = TutorialDependency.init()
    static var testValue: TutorialChannel = TutorialDependency.init()
}

extension DependencyValues {
    var tutorial: TutorialChannel {
        get { self[TutorialDependency.self] }
        set { self[TutorialDependency.self] = newValue }
    }
}
