import SwiftUI
import ComposableArchitecture
import Combine

// Subscribe to tutorial updates in your view

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Dependency(\.tutorial) var tutorial
    
    @State private var currentStep: TutorialDetails?
    
    var body: some View {
        VStack {
            // Your normal UI
            Button("Edit") {
                store.send(.tappedEditButton)
            }
            
            Button("New Plan") {
                store.send(.tappedNewPlan)
            }
            
            Button("Next") {
                store.send(.tappedNext)
            }
        }
        .onReceive(tutorial.publisher) { step in
            // Receive tutorial step updates
            self.currentStep = step
        }
    }
}
