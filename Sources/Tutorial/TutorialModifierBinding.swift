//
//  TutorialModifierBinding.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/9/25.
//

import SwiftUI
import Combine
import Dependencies

struct TutorialModifierBinding: ViewModifier {
    @Binding var tutorial: TutorialDetails?
    let viewID: String
    
    init(
        _ tutorialDetail: Binding<TutorialDetails?>,
        viewID: String
    ) {
        self.viewID = viewID
        self._tutorial = tutorialDetail
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                UIKitPopover(item: $tutorial, content: {
                    if let details = tutorial?.detail {
                        Text("\(details)")
                    }
                })
            }
    }
}


extension View {
    func tutorial(
        viewID: String
    ) -> some View {
        modifier(TutorialModifier(viewID: viewID))
    }
    
    func tutorial(
        bind: Binding<TutorialDetails?>,
        viewID: String
    ) -> some View {
        modifier(TutorialModifierBinding(bind, viewID: viewID))
    }
}


struct TutorialModifier: ViewModifier {
    @State var currentModifier: TutorialDetails?
    let viewID: String
    let publisher: AnyPublisher<TutorialDetails?, Never>
    
    init(
        viewID: String
    ) {
        @Dependency(\.tutorial) var tutorial
        @Dependency(\.mainQueue) var mainQueue
        
        self.publisher = tutorial.publisher
            .filter({ $0?.displayID == viewID })
            .debounce(for: .milliseconds(200), scheduler: mainQueue)
            .eraseToAnyPublisher()
        self.viewID = viewID
    }
    
    func body(content: Content) -> some View {
        content
            .onReceive(publisher, perform: { newValue in
                currentModifier  = newValue
            })
            .sensoryFeedback(.selection, trigger: currentModifier)
            .background {
                UIKitPopover(item: $currentModifier, content: {
                    if let details = currentModifier?.detail {
                        Text("\(details)")
                    }
                })
                .onTapGesture {
                    currentModifier = nil
                }
            }
    }
}


#Preview {
    NavigateHomePreview()
        .tint(Color.theme.button)
}
