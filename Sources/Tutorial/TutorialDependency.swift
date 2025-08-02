//
//  TutorialDependency.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/7/25.
//

import Foundation
@preconcurrency import Combine
import Dependencies

@available(macOS 12, *)
protocol TutorialChannel: Sendable {
    func path(_ path: TutorialDetails?)
    func stopTutorial()
    
    /// Publishes next tutorial step if applicable
    var publisher: AnyPublisher<TutorialDetails?, Never> { get }
    /// Sends the last details before canceled
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> { get }
}

@available(macOS 12, *)
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

@available(macOS 12, *)
extension TutorialDependency: @preconcurrency DependencyKey {
    @MainActor static var liveValue: TutorialChannel = TutorialDependency.init()
    static let testValue: TutorialChannel = TutorialDependency.init()
}

@available(macOS 12, *)
extension DependencyValues {
    var tutorial: TutorialChannel {
        get { self[TutorialDependency.self] }
        set { self[TutorialDependency.self] = newValue }
    }
}
