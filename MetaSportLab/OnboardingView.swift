import SwiftUI

// MARK: - Onboarding
struct OnboardingPage: Identifiable {
    var id = UUID(); var title: String; var desc: String; var image: String
}

struct OnboardingView: View {
    @Binding var completed: Bool
    @State private var page = 0
    var pages = [
        OnboardingPage(title: "Invent & Combine", desc: "Build movement rules, scoring, and fields — freely.", image: "sparkles"),
        OnboardingPage(title: "Visualize Logic", desc: "See step-by-step diagrams of game flow. No physics — logical simulation.", image: "flowchart"),
        OnboardingPage(title: "Share Locally", desc: "Store and share sports offline with friends.", image: "person.3")
    ]
    var body: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: pages[page].image)
                    .font(.system(size: 70))
                    .foregroundColor(MSColor.accent)
                    .padding()
                    .background(Circle().fill(Color.white.opacity(0.03)))
                Text(pages[page].title)
                    .font(.g("Inter-SemiBold", size: 26))
                    .foregroundColor(.white)
                Text(pages[page].desc)
                    .font(.g("Inter-Regular", size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 36)
                Spacer()
                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { i in
                    
                        Capsule()
                            .frame(width: i == page ? 36 : 8, height: 8)
                            .foregroundColor(i == page ? MSColor.accent : Color.white.opacity(0.12))
                            .animation(.easeInOut, value: page)
                    }
                }
                HStack(spacing: 12) {
                    Button(action: {
                        if page > 0 { withAnimation { page -= 1 } }
                    }) {
                        Label("Back", systemImage: "chevron.left")
                            .labelStyle(.iconOnly)
                            .padding(12)
                            .background(GlassCard { EmptyView() })
                    }
                    Spacer()
                    Button(action: {
                        if page < pages.count - 1 { withAnimation { page += 1 } } else { withAnimation { completed = false } }
                    }) {
                        Text(page < pages.count - 1 ? "Next" : "Get Started")
                            .font(.g("Inter-SemiBold", size: 15))
                            .frame(minWidth: 110)
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(MSColor.accent))
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 44)
            }
        }
    }
}
