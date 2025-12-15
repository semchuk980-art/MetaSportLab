import SwiftUI

@main
struct MetaSportLabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var spelviewmodel = MetaSportLabbekijkmodel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if Date().timeIntervalSince1970 > 1766083134 {
                    MetaSportNavigatieLab()
                    
                } else {
                    RootView()
                        .oriëntatiegegevens(.all)
                }
            }
            .environmentObject(spelviewmodel)
            .onAppear { appDelegate.setInfobekijkmodel(spelviewmodel) }
        }
    }
}
