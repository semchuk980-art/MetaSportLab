import SwiftUI

struct HomeHubView: View {
    @EnvironmentObject var sportStore: SportStore
    @Binding var selection: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // MARK: - HERO
                VStack(alignment: .leading, spacing: 8) {
                    Text("Welcome to MetaSport Lab")
                        .font(.g("Inter-SemiBold", size: 30))
                        .foregroundColor(.white)

                    Text("Invent, prototype, and simulate entirely new sports.")
                        .font(.g("Inter-Regular", size: 15))
                        .foregroundColor(.white.opacity(0.75))
                }

                // MARK: - QUICK START + RECENT (RESPONSIVE)
                GeometryReader { geo in
                    let isCompact = geo.size.width < 700

                    Group {
                        if isCompact {
                            VStack(spacing: 16) {
                                quickStartCard
                                recentDesignsCard
                            }
                        } else {
                            HStack(spacing: 16) {
                                quickStartCard
                                recentDesignsCard
                            }
                        }
                    }
                }
                .frame(height: 300)

                // MARK: - MODULES
                VStack(alignment: .leading, spacing: 12) {
                    Text("Modules")
                        .font(.g("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)

                    Text("Each module is independent and composable.")
                        .font(.g("Inter-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.6))
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        moduleCard(
                            title: "Field Designer",
                            systemIcon: "square.split.2x2",
                            destination: "Design the Field"
                        )

                        moduleCard(
                            title: "Rules & Scoring",
                            systemIcon: "list.bullet.rectangle",
                            destination: "Rules & Scoring"
                        )

                        moduleCard(
                            title: "Team Roles",
                            systemIcon: "person.3.fill",
                            destination: "Team Roles"
                        )

                        moduleCard(
                            title: "Simulation",
                            systemIcon: "play.rectangle.fill",
                            destination: "Simulation"
                        )

                        moduleCard(
                            title: "Community Vault",
                            systemIcon: "tray.full.fill",
                            destination: "Community Vault"
                        )
                    }
                    .padding(.vertical, 6)
                }

                Spacer(minLength: 30)
            }
            .padding()
        }
    }

    // MARK: - QUICK START CARD
    private var quickStartCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Quick Start")
                    .font(.g("Inter-SemiBold", size: 17))
                    .foregroundColor(.white)

                Text("Start from scratch or use a proven template.")
                    .font(.g("Inter-Regular", size: 13))
                    .foregroundColor(.white.opacity(0.7))

                Spacer()

                HStack(spacing: 12) {

                    // PRIMARY CTA
                    Button {
                        withAnimation(.spring()) {
                            selection = "Create a Sport"
                        }
                    } label: {
                        Label("New Sport", systemImage: "plus.circle.fill")
                            .font(.g("Inter-SemiBold", size: 15))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        MSColor.nodeBlue,
                                        MSColor.nodeBlue.opacity(0.85)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .foregroundColor(.black)
                            .cornerRadius(14)
                    }

                    // SECONDARY CTA
                    Button {
                        withAnimation(.spring()) {
                            selection = "Create a Sport"
                        }
                    } label: {
                        Label("Template", systemImage: "doc.on.doc.fill")
                            .font(.g("Inter-Medium", size: 14))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(MSColor.nodePink.opacity(0.9), lineWidth: 1.5)
                            )
                            .foregroundColor(MSColor.nodePink)
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
    }

    // MARK: - RECENT DESIGNS CARD
    private var recentDesignsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Designs")
                    .font(.g("Inter-SemiBold", size: 17))
                    .foregroundColor(.white)

                if sportStore.sports.isEmpty {
                    Text("No recent designs yet.")
                        .font(.g("Inter-Regular", size: 13))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 6)
                } else {
                    ForEach(sportStore.sports.suffix(3).reversed()) { sport in
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(sport.name)
                                    .font(.g("Inter-Medium", size: 14))
                                    .foregroundColor(.white)

                                Text(sport.summary)
                                    .font(.g("Inter-Regular", size: 11))
                                    .foregroundColor(.white.opacity(0.6))
                                    .lineLimit(1)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.05))
                        )
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, minHeight: 150)
    }

    // MARK: - MODULE CARD
    @ViewBuilder
    func moduleCard(title: String, systemIcon: String, destination: String) -> some View {
        GlassCard {
            VStack(spacing: 14) {
                Image(systemName: systemIcon)
                    .font(.system(size: 30))
                    .foregroundColor(MSColor.nodeBlue)

                Text(title)
                    .font(.g("Inter-Medium", size: 14))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 130, height: 130)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    selection = destination
                }
            }
        }
    }
}

#Preview {
    HomeHubView(selection: .constant(nil))
        .environmentObject(SportStore())
}
