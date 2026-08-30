import SwiftUI
import ComposableArchitecture
import Combine

// Handle tutorial completion

struct CompletionView: View {
    let store: StoreOf<AppFeature>
    @Dependency(\.tutorial) var tutorial
    
    @State private var currentStep: TutorialDetails?
    @State private var showCompletionCelebration = false
    
    var body: some View {
        ZStack {
            AppContent(store: store)
            
            // Show celebration when tutorial completes
            if showCompletionCelebration {
                TutorialCompletionView()
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .onReceive(tutorial.publisher) { step in
            if let step {
                self.currentStep = step
            } else {
                // step is nil - tutorial complete!
                withAnimation(.spring()) {
                    showCompletionCelebration = true
                }
                
                // Hide celebration after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showCompletionCelebration = false
                    }
                }
            }
        }
    }
}

struct TutorialCompletionView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
            
            Text("Tutorial Complete!")
                .font(.title)
                .bold()
            
            Text("You're ready to use the app!")
                .foregroundColor(.secondary)
        }
        .padding(40)
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct AppContent: View {
    let store: StoreOf<AppFeature>
    var body: some View {
        Text("App")
    }
}
