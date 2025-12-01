import SwiftUI


struct PocketMenuItem: Identifiable {
    var id = UUID(); var title: String; var subtitle: String; var systemImage: String
}

struct MenuView: View {
    var items: [PocketMenuItem] = [
        .init(title: "Create a Sport", subtitle: "Start from scratch", systemImage: "plus.app.fill"),
        .init(title: "Design the Field", subtitle: "Canvas & zones", systemImage: "square.grid.3x3.fill"),
        .init(title: "Rules & Scoring", subtitle: "Behavior & points", systemImage: "list.bullet.rectangle"),
        .init(title: "Team Roles", subtitle: "Generate roles & loadouts", systemImage: "person.2.fill"),
        .init(title: "Simulation", subtitle: "Step-based flow", systemImage: "play.circle"),
        .init(title: "Community Vault", subtitle: "Offline sharing", systemImage: "tray.and.arrow.up"),
        .init(title: "About", subtitle: "MetaSport Lab", systemImage: "info.circle")
    ]
    @Binding var selection: String?
    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                ForEach(items) { item in
                    Button(action: { withAnimation { selection = item.title } }) {
                        HStack(spacing: 12) {
                            Image(systemName: item.systemImage)
                                .font(.system(size: 20))
                                .foregroundColor(.white.opacity(0.9))
                                .frame(width: 44, height: 44)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.03)))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.title).font(.g("Inter-SemiBold", size: 16)).foregroundColor(.white)
                                Text(item.subtitle).font(.g("Inter-Regular", size: 12)).foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.6))
                        }
                        .padding(14)
                        .background(GlassCard { EmptyView() })
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    MenuView(selection: .constant("Create a Sport"))
}
