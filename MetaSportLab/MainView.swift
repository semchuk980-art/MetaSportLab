import SwiftUI

struct MainView: View {
    @State private var selection: String? = nil
    @State private var showBottomMenu = false
    @StateObject var sportStore = SportStore()
    
    var body: some View {
        ZStack {
            // MAIN CONTENT
            VStack {
                if selection == nil { HomeHubView()
                        .environmentObject(sportStore)
                }
                else if selection == "Create a Sport" { CreateSportView()
                        .environmentObject(sportStore)
                }
                else if selection == "Design the Field" { FieldDesignerView() }
                else if selection == "Rules & Scoring" { RulesBuilderView() }
                else if selection == "Team Roles" { TeamRolesGeneratorView() }
                else if selection == "Simulation" { SimulationView() }
                else if selection == "Community Vault" { CommunityVaultView()
                        .environmentObject(sportStore)
                }
                else if selection == "About" { AboutView() }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // BOTTOM MENU (slides up/down)
            VStack {
                Spacer()

                if showBottomMenu {
                    bottomMenu
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Toggle button always visible
                toggleButton
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: showBottomMenu)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Bottom Menu View
    var bottomMenu: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("MetaSport Lab")
                .font(.g("Inter-SemiBold", size: 20)).foregroundColor(.white)
            Text("Inventive Sports Playground")
                .font(.g("Inter-Regular", size: 12)).foregroundColor(.white.opacity(0.7))

            MenuView(selection: $selection)

            Spacer(minLength: 4)

            Text("v0.1 — offline")
                .font(.g("Inter-Regular", size: 11))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 300)
        .background(GlassCard { EmptyView() })
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
        .shadow(radius: 20)
    }

    // MARK: - Toggle Button
    var toggleButton: some View {
        Button(action: { showBottomMenu.toggle() }) {
            Image(systemName: showBottomMenu ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                .font(.system(size: 32))
                .foregroundColor(.white.opacity(0.9))
                .padding(.bottom, 16)
        }
    }
}

// MARK: - Previews
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            MainView()
        }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
