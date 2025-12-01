import SwiftUI

struct RootView: View {
    @State private var showOnboarding = !(UserDefaults.standard.bool(forKey: "ms_onboarded"))
    
    @State private var showLoader = true
    var body: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            if showLoader {
                LoaderView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation(.easeOut) { showLoader = false } }
                    }
            } else {
                MainView()
            }
        }
        .onChange(of: showOnboarding) { val in if !val { UserDefaults.standard.setValue(true, forKey: "ms_onboarded") } }
        .sheet(isPresented: $showOnboarding, onDismiss: { showOnboarding = false }) {
            OnboardingView(completed: $showOnboarding)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            RootView()
        }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}


