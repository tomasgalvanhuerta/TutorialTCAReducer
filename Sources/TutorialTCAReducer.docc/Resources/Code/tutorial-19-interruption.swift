import SwiftUI
import ComposableArchitecture
import Combine

// Detect tutorial interruptions

struct TutorialView: View {
    let store: StoreOf<AppFeature>
    @Dependency(\.tutorial) var tutorial
    
    @State private var currentStep: TutorialDetails?
    @State private var showingInterruptionAlert = false
    
    var body: some View {
        ContentView(store: store, currentStep: currentStep)
            .onReceive(tutorial.publisher) { step in
                self.currentStep = step
            }
            .onReceive(tutorial.cancelCurrent) { cancelledStep in
                // User navigated away or interrupted the tutorial
                if let step = cancelledStep {
                    handleInterruption(step)
                }
            }
            .alert("Tutorial Interrupted", isPresented: $showingInterruptionAlert) {
                Button("Restart Tutorial") {
                    restartTutorial()
                }
                Button("Continue Without Tutorial") {
                    dismissTutorial()
                }
            } message: {
                Text("Would you like to restart the tutorial or continue on your own?")
            }
    }
    
    func handleInterruption(_ step: TutorialDetails) {
        showingInterruptionAlert = true
    }
    
    func restartTutorial() {
        // Reset tutorial state
        store.send(.resetTutorial)
    }
    
    func dismissTutorial() {
        // Clear tutorial
    }
}

struct ContentView: View {
    let store: StoreOf<AppFeature>
    let currentStep: TutorialDetails?
    
    var body: some View {
        Text("App Content")
    }
}
