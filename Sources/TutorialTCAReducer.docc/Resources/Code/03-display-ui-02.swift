import Foundation
import Combine

/**
 TutorialChannel protocol - Communication between Tutorial reducer and UI
 */
protocol TutorialChannel {
    /// Called when moving to a new tutorial step
    func path(_ path: TutorialDetails?)
    
    /// Called when the tutorial is complete
    func stopTutorial()
    
    /// Publisher for observing tutorial step changes
    var publisher: AnyPublisher<TutorialDetails?, Never> { get }
    
    /// Publisher for canceling the current tutorial
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> { get }
}

/**
 Example implementation using Combine subjects
 */
final class MyTutorialChannel: TutorialChannel {
    private let pathSubject = CurrentValueSubject<TutorialDetails?, Never>(nil)
    private let cancelSubject = PassthroughSubject<TutorialDetails?, Never>()
    
    func path(_ path: TutorialDetails?) {
        pathSubject.send(path)
    }
    
    func stopTutorial() {
        // Clear the current step and notify subscribers
        pathSubject.send(nil)
    }
    
    var publisher: AnyPublisher<TutorialDetails?, Never> {
        pathSubject.eraseToAnyPublisher()
    }
    
    var cancelCurrent: AnyPublisher<TutorialDetails?, Never> {
        cancelSubject.eraseToAnyPublisher()
    }
    
    /// Call this to manually cancel a tutorial
    func cancel() {
        cancelSubject.send(pathSubject.value)
        stopTutorial()
    }
}

// Register as a dependency
extension DependencyValues {
    var tutorial: TutorialChannel {
        get { self[TutorialChannelKey.self] }
        set { self[TutorialChannelKey.self] = newValue }
    }
}

private enum TutorialChannelKey: DependencyKey {
    static let liveValue: TutorialChannel = MyTutorialChannel()
}
