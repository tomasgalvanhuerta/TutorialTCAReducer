import SwiftUI
import ComposableArchitecture

struct PlanView: View {
    @Bindable var store: StoreOf<PlanDomain>
    @State private var currentTutorialStep: TutorialDetails?
    
    var body: some View {
        VStack {
            Text("My Plans")
                .font(.largeTitle)
            
            // Edit Plan button - first tutorial step
            Button("Edit Plan") {
                store.send(.tappedEditPlanButton)
            }
            .tutorialHighlight(
                isActive: currentTutorialStep?.displayID == "EditPlanButton",
                message: currentTutorialStep?.detail
            )
            
            if store.isEditingPlan {
                // New Plan button - second tutorial step
                Button("New Plan") {
                    store.send(.tappedNewPlanButton)
                }
                .tutorialHighlight(
                    isActive: currentTutorialStep?.displayID == "NewPlanButton",
                    message: currentTutorialStep?.detail
                )
                
                // Next button - third tutorial step
                Button("Next") {
                    store.send(.tappedNextButton)
                }
                .tutorialHighlight(
                    isActive: currentTutorialStep?.displayID == "NextButton",
                    message: currentTutorialStep?.detail
                )
            }
        }
        .onAppear {
            // Subscribe to tutorial updates
            @Dependency(\.tutorial) var tutorial
            
            Task {
                for await step in tutorial.publisher.values {
                    currentTutorialStep = step
                }
            }
        }
    }
}
