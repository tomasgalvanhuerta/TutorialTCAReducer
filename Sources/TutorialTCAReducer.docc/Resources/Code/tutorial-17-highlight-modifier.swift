import SwiftUI

// Create a reusable tutorial highlight modifier

extension View {
    func tutorialHighlight(
        isActive: Bool,
        instruction: TutorialDetails?
    ) -> some View {
        self.overlay {
            if isActive {
                TutorialHighlightOverlay(instruction: instruction)
            }
        }
    }
}

struct TutorialHighlightOverlay: View {
    let instruction: TutorialDetails?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Highlight border
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue, lineWidth: 3)
                .shadow(color: .blue.opacity(0.5), radius: 8)
            
            // Tooltip with instruction
            if let instruction {
                VStack(alignment: .leading, spacing: 4) {
                    Text(instruction.detail)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(6)
                    
                    // Arrow pointing to element
                    Triangle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 8)
                }
                .offset(y: -50)
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.spring(), value: instruction?.id)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

// Usage:
// Button("Action") { }
//     .tutorialHighlight(
//         isActive: currentStep?.displayID == "actionButton",
//         instruction: currentStep
//     )
