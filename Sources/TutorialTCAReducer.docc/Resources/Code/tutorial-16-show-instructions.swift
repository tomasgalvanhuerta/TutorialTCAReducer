import SwiftUI
import ComposableArchitecture

// Display instruction text to guide users

struct AppView: View {
    let store: StoreOf<AppFeature>
    @Dependency(\.tutorial) var tutorial
    
    @State private var currentStep: TutorialDetails?
    
    var body: some View {
        VStack {
            // Show tutorial instruction at the top
            if let step = currentStep {
                TutorialBanner(step: step)
                    .transition(.move(edge: .top))
            }
            
            Spacer()
            
            Button("Edit") {
                store.send(.tappedEditButton)
            }
            .tutorialHighlight(
                isActive: currentStep?.displayID == "editButton",
                instruction: currentStep
            )
            
            Button("New Plan") {
                store.send(.tappedNewPlan)
            }
            .tutorialHighlight(
                isActive: currentStep?.displayID == "newPlanButton",
                instruction: currentStep
            )
        }
        .onReceive(tutorial.publisher) { step in
            withAnimation {
                self.currentStep = step
            }
        }
    }
}

struct TutorialBanner: View {
    let step: TutorialDetails
    
    var body: some View {
        Text(step.detail)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
    }
}
