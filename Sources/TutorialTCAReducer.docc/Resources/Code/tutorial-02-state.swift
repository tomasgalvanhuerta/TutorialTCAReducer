import Foundation

// TutorialState holds the configuration and tracks progress
struct TutorialState<ParentAction: Equatable>: Equatable, Identifiable {
    typealias Path = TutorialInstruction<ParentAction>
    
    // Array of steps to complete
    var steps: [Path]
    
    // Overall tutorial title
    let title: String
    
    // Display ID of the current step (for UI matching)
    var displayID: String? {
        steps.first?.detail.displayID
    }
    
    // The current step users need to complete
    var currentTutorialStep: Path? {
        steps.first
    }
    
    // Unique identifier for this tutorial
    var id = UUID()
}
