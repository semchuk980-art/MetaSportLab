import UIKit
import SwiftUI

final class MetaSportoriëntatiegegevensLab {
    static func oriëntatiePositie(_ orientationLock: UIInterfaceOrientationMask) {
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes.forEach { scene in
                if let windowScene = scene as? UIWindowScene {
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: orientationLock))
                }
            }
            UIViewController.attemptRotationToDeviceOrientation()
        } else {
            if orientationLock == .landscape {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
            } else {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            }
        }
    }
}

extension View {
    @ViewBuilder
    func oriëntatiegegevens(_ orientation: UIInterfaceOrientationMask) -> some View {
        self
            .onAppear() {
                AppDelegate.orientationLock = orientation
            }
            .onDisappear() {
                let currentOrientation = AppDelegate.orientationLock
                AppDelegate.orientationLock = currentOrientation
            }
    }
}
