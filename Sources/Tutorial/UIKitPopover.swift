//
//  UIKitPopover.swift
//  MoreToe Works
//
//  Created by Tomas Galvan-Huerta on 7/9/25.
//

import UIKit
import SwiftUI

struct UIKitPopover<Content: View>: UIViewControllerRepresentable {
    @Binding var item: TutorialDetails?
    let content: Content

    init(item: Binding<TutorialDetails?> , @ViewBuilder content: () -> Content) { // Add T to (T)
        self._item = item
        self.content = content()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view = UIView()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard item != nil, uiViewController.presentedViewController == nil else { return }

        let viewController = UIHostingController(rootView: content)
        viewController.modalPresentationStyle = .popover
        viewController.preferredContentSize = CGSize(width: 200, height: 120)

        if let popover = viewController.popoverPresentationController {
            popover.sourceView = uiViewController.view
            popover.sourceRect = uiViewController.view.bounds
            popover.permittedArrowDirections = [.down, .up]
            popover.delegate = context.coordinator
        }

        uiViewController.present(viewController, animated: true)
    }
    

    func makeCoordinator() -> Coordinator {
        Coordinator($item)
    }

    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        @Binding var item: TutorialDetails?
        
        init(_ item: Binding<TutorialDetails?>) {
            self._item = item
        }
        
        func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
            item = nil
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
    }
}
