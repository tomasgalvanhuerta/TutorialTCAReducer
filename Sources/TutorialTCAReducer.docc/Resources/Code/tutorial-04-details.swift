import SwiftUI
import Dependencies

// TutorialDetails contains information shown to users
struct TutorialDetails: Equatable, Identifiable, Sendable {
    init(_ displayID: String, _ detail: AttributedString) {
        @Dependency(\.uuid) var uuid
        self.displayID = displayID
        self.detail = detail
        self.id = uuid()
    }

    // Rich text instructions
    let detail: AttributedString
    
    // ID for matching to UI elements
    let displayID: String
    
    // Unique identifier
    let id: UUID
}

// Example: Creating tutorial details
let details = TutorialDetails(
    "createButton",
    "Tap here to create your first plan"
)
