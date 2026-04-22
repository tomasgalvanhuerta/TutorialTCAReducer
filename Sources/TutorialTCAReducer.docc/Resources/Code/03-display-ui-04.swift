import SwiftUI

/**
 Custom view modifier for highlighting tutorial steps
 */
struct TutorialHighlightModifier: ViewModifier {
    let isActive: Bool
    let message: AttributedString?
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    // Highlight ring around the target
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 3)
                        .shadow(color: .blue.opacity(0.5), radius: 8)
                        .animation(.easeInOut(duration: 0.8).repeatForever(), value: isActive)
                }
            }
            .overlay(alignment: .top) {
                if isActive, let message {
                    // Tooltip with instructions
                    VStack(spacing: 8) {
                        Text(message)
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .shadow(radius: 4)
                            }
                        
                        // Arrow pointing to the button
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.blue)
                    }
                    .offset(y: -80)
                    .transition(.scale.combined(with: .opacity))
                }
            }
    }
}

extension View {
    func tutorialHighlight(isActive: Bool, message: AttributedString?) -> some View {
        modifier(TutorialHighlightModifier(isActive: isActive, message: message))
    }
}

// Usage in your view:
struct ExampleView: View {
    @State private var currentStep: TutorialDetails?
    
    var body: some View {
        Button("Edit Plan") {
            // Action
        }
        .tutorialHighlight(
            isActive: currentStep?.displayID == "EditPlanButton",
            message: currentStep?.detail
        )
    }
}
