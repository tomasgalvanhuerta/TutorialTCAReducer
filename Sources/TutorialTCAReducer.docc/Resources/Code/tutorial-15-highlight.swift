import SwiftUI
import ComposableArchitecture

// Highlight UI elements based on displayID

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Dependency(\.tutorial) var tutorial
    
    @State private var currentStep: TutorialDetails?
    
    var body: some View {
        VStack {
            Button("Edit") {
                store.send(.tappedEditButton)
            }
            .overlay {
                // Highlight when this is the current step
                if currentStep?.displayID == "editButton" {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                        .animation(.easeInOut, value: currentStep)
                }
            }
            
            Button("New Plan") {
                store.send(.tappedNewPlan)
            }
            .overlay {
                if currentStep?.displayID == "newPlanButton" {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                }
            }
            
            Button("Next") {
                store.send(.tappedNext)
            }
            .overlay {
                if currentStep?.displayID == "nextButton" {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 3)
                }
            }
        }
        .onReceive(tutorial.publisher) { step in
            self.currentStep = step
        }
    }
}
