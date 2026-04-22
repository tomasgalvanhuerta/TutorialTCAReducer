//
//  TutorialModifier.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/9/25.
//

import SwiftUI
import Combine
import Dependencies

extension View {
    func tutorial(
        viewID: CustomStringConvertible
    ) -> some View {
        modifier(TutorialModifier(viewID: viewID.description))
    }
}


struct TutorialModifier: ViewModifier {
    @State var currentModifier: TutorialDetails?
    let viewID: String
    let publisher: AnyPublisher<TutorialDetails?, Never>
    
    init(
        viewID: String,
    ) {
        @Dependency(\.tutorial) var tutorial
        @Dependency(\.mainQueue) var mainQueue
        
        self.publisher = tutorial.publisher
            .filter({ $0?.displayID.description == viewID })
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
            .popover(item: $currentModifier, content: { item in
                DynamicTextDisplay(details: item.detail)
                    .onTapGesture {
                        currentModifier = nil
                    }
            })
            .presentationCompactAdaptation(.popover)
    }
}

extension TutorialModifier {
    init(detail: String) {
        publisher = Empty().eraseToAnyPublisher()
        self.viewID = "asd"
        self._currentModifier = State(initialValue: TutorialDetails("123werwerwerwer45", AttributedString("123123123123")))
    }
}

private struct DynamicTextDisplay: View {
    let details: AttributedString
    
    var body: some View {
        if details.characters.count > 300 {
            ScrollView {
                Text("\(details)")
                    .safeAreaPadding()
                    .font(.title2)
            }
        } else {
            Text("\(details)")
                .safeAreaPadding(33)
                .font(.title2)
        }
    }
}


#Preview {
    NavigationStack {
        VStack {
            Text("")
                .frame(width: 400, height: 400, alignment: .center)
                .safeAreaPadding(10)
                .modifier(TutorialModifier(detail: Array(repeating: 1234567890, count: 5).description))
        }
    }
}
