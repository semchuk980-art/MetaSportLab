import SwiftUI

// MARK: - Helpers
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
 
extension Font {
    // Use Google fonts by adding them to the project and Info.plist and using the postscript name here.
    // Example: Font.custom("Inter-Regular", size: 16)
    static func g(_ name: String, size: CGFloat) -> Font {
        return Font.custom(name, size: size)
    }
}



// MARK: - Theme
enum MSColor {
    static let background = Color(hex: "0B1020")
    static let accent = Color(hex: "7CE7B5")
    static let nodeBlue = Color(hex: "62A9FF")
    static let nodePink = Color(hex: "FF7AC6")
    static let nodeYellow = Color(hex: "FFD36E")
    static let panelBG = Color.white.opacity(0.06)
}

// MARK: - Rule Node
struct RuleNodeView: View {
    var title: String
    var color: Color
    var systemImage: String
    var size: CGFloat = 46
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.18))
                    .frame(width: size, height: size)
                    .overlay(Circle().stroke(color.opacity(0.35), lineWidth: 1))
                Image(systemName: systemImage)
                    .font(.system(size: size * 0.45))
                    .foregroundColor(color)
            }
            Text(title)
                .font(.g("Inter-Regular", size: 12))
                .foregroundColor(.white.opacity(0.9))
        }
    }
}

// MARK: - Expandable Rule Block
struct RuleBlock: Identifiable {
    var id = UUID()
    var title: String
    var summary: String
    var details: String
    var nodeColor: Color
    var icon: String
}

struct ExpandingRuleBlock: View {
    var rule: RuleBlock
    @State private var expanded: Bool = false
    @Namespace var ns
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                RuleNodeView(title: "", color: rule.nodeColor, systemImage: rule.icon, size: 42)
                VStack(alignment: .leading, spacing: 6) {
                    Text(rule.title)
                        .font(.g("Inter-SemiBold", size: 16))
                        .foregroundColor(.white)
                    Text(rule.summary)
                        .font(.g("Inter-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.75))
                }
                Spacer()
                Button(action: { withAnimation(.spring(response: 0.45, dampingFraction: 0.8, blendDuration: 0)) { expanded.toggle() } }) {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.8))
                        .padding(8)
                        .background(Color.white.opacity(0.03))
                        .clipShape(Circle())
                }
            }
            if expanded {
                Divider().background(Color.white.opacity(0.06))
                Text(rule.details)
                    .font(.g("Inter-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.85))
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(14)
        .background(GlassCard { EmptyView() })
    }
}

// MARK: - Loader
struct                     LaderUitzichtSport: View {
    @State private var animeren = false
    var body: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .opacity(0.12)
                        .frame(width: 88, height: 88)
                    Circle()
                        .trim(from: 0, to: 0.7)
                        .stroke(MSColor.accent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(Angle(degrees: animeren ? 360 : 0))
                        .frame(width: 88, height: 88)
                        .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: animeren)
                    Image(systemName: "sportscourt")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                Text("MetaSport Lab")
                    .font(.g("Inter-SemiBold", size: 20))
                    .foregroundColor(.white)
                Text("Invent new sports — mix rules, fields and scoring.")
                    .font(.g("Inter-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.75))
            }
            .onAppear { animeren = true }
        }
    }
}



// MARK: - Placeholder Builder Views (first pass)


struct RulesBuilderView: View {
    @State private var rules: [RuleBlock] = [
        RuleBlock(title: "Movement", summary: "Team may dash or stroll", details: "Define allowed moves per turn: dash (2 squares), dash+pass, slide, grapple (non-contact).", nodeColor: MSColor.nodeBlue, icon: "figure.walk"),
        RuleBlock(title: "Scoring", summary: "Three ways to score", details: "Scoring zones: goal line (2 pts), air goal (3 pts), trick combo (5 pts). Define conditions.", nodeColor: MSColor.nodeYellow, icon: "flag.checkered")
    ]
    var body: some View {
        VStack(spacing: 12) {
            Text("Rules & Scoring Builder")
                .font(.g("Inter-SemiBold", size: 20))
                .foregroundColor(.white)
            ScrollView { VStack(spacing: 12) { ForEach(rules) { r in ExpandingRuleBlock(rule: r) } } }
        }
        .padding()
    }
}

struct ScoringBuilderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Scoring Builder")
                .font(.g("Inter-SemiBold", size: 20))
                .foregroundColor(.white)
            Text("Compose scoring chains and multipliers.")
                .font(.g("Inter-Regular", size: 14))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            Image(systemName: "function")
                .font(.system(size: 68))
            Spacer()
        }
        .padding()
    }
}



// MARK: - Simulation View (diagrammatic, step-based)
struct SimulationStep: Identifiable {
    var id = UUID(); var title: String; var description: String; var color: Color
}

struct SimulationView: View {
    @State private var steps: [SimulationStep] = [
        .init(title: "Kickoff", description: "Initial possession — choose launch move.", color: MSColor.nodeBlue),
        .init(title: "Contest", description: "Opposition can contest possession within zone.", color: MSColor.nodePink),
        .init(title: "Finish", description: "Attempt scoring action.", color: MSColor.nodeYellow)
    ]
    @State private var current = 0
    var body: some View {
        VStack(spacing: 18) {
            Text("Simulation")
                .font(.g("Inter-SemiBold", size: 22)).foregroundColor(.white)
            
            HStack(alignment: .top, spacing: 16) {
                VStack(spacing: 24) {
                    ForEach(Array(steps.enumerated()), id: \.1.id) { idx, s in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 12) {
                                Circle().fill(s.color).frame(width: 12, height: 12)
                                Text(s.title).font(.g("Inter-SemiBold", size: 16)).foregroundColor(.white)
                                Spacer()
                                if idx == current { Text("Active").font(.g("Inter-Regular", size: 12)).foregroundColor(.white.opacity(0.7)) }
                            }
                            if idx == current {
                                Text(s.description).font(.g("Inter-Regular", size: 13)).foregroundColor(.white.opacity(0.8))
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                            }
                        }
                        .padding(12)
                        .background(GlassCard { EmptyView() })
                        .onTapGesture { withAnimation(.spring()) { current = idx } }
                    }
                }
                .frame(maxWidth: 340)
                Spacer()
                // Diagrammatic panel — simplified logical visualization
                ZStack {
                    RoundedRectangle(cornerRadius: 18).fill(Color.black.opacity(0.12)).frame(minWidth: 220, minHeight: 260)
                    VStack {
                        Text("Flow Diagram")
                            .font(.g("Inter-SemiBold", size: 16)).foregroundColor(.white)
                        Spacer()
                        // Simple nodes connected
                        HStack(spacing: 18) {
                            NodeDiagramBox(title: steps[0].title, color: steps[0].color)
                            VStack { LineView(); LineView(); LineView() }
                            NodeDiagramBox(title: steps[1].title, color: steps[1].color)
                            VStack { LineView(); LineView(); LineView() }
                            NodeDiagramBox(title: steps[2].title, color: steps[2].color)
                        }
                        Spacer()
                    }
                    .padding(18)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
        .padding()
    }
}

struct NodeDiagramBox: View {
    var title: String; var color: Color
    var body: some View {
        VStack(spacing: 8) {
            Circle().fill(color).frame(width: 20, height: 20)
            Text(title).font(.g("Inter-SemiBold", size: 12)).foregroundColor(.white)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.03)))
    }
}

struct LineView: View {
    var body: some View {
        Rectangle().fill(Color.white.opacity(0.06)).frame(width: 28, height: 2)
    }
}

// MARK: - Community Vault (local sharing)


// MARK: - About
struct AboutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("MetaSport Lab")
                .font(.g("Inter-SemiBold", size: 22)).foregroundColor(.white)
            Text("A creative playground to invent, visualize, and simulate imaginary sports. Offline-first; privacy respected.")
                .font(.g("Inter-Regular", size: 14))
                .foregroundColor(.white.opacity(0.8))
            Spacer()
            HStack(spacing: 18) {
                Link(destination: URL(string: "https://www.termsfeed.com/live/c6e29425-89d7-4661-85c2-f560f5b232f8")!) { Label("Docs", systemImage: "book") }
                Link(destination: URL(string: "https://www.termsfeed.com/live/c6e29425-89d7-4661-85c2-f560f5b232f8")!) { Label("License", systemImage: "doc.text") }
            }
            .foregroundColor(.white)
            Spacer()
        }
        .padding()
    }
}

// MARK: - Root App





// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
 
