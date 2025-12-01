import SwiftUI

struct HomeHubView: View {
    @EnvironmentObject var sportStore: SportStore
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Welcome
                Text("Welcome to MetaSport Lab")
                    .font(.g("Inter-SemiBold", size: 28))
                    .foregroundColor(.white)
                
                Text("Begin by choosing a module or quick start action below. Each module is modular and composable.")
                    .font(.g("Inter-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                // MARK: - Quick Start & Recent Designs
                HStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Quick Start")
                                .font(.g("Inter-SemiBold", size: 16))
                                .foregroundColor(.white)
                            Text("Create a new sport from blank or template.")
                                .font(.g("Inter-Regular", size: 12))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Spacer()
                            
                            HStack(spacing: 12) {
                                Button {
                                    // Action: open CreateSportView blank
                                } label: {
                                    Label("New Sport", systemImage: "plus.circle.fill")
                                        .font(.g("Inter-SemiBold", size: 14))
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(MSColor.nodeBlue.opacity(0.9))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                                
                                Button {
                                    // Action: open template picker
                                } label: {
                                    Label("Template", systemImage: "doc.on.doc.fill")
                                        .font(.g("Inter-SemiBold", size: 14))
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                        .background(MSColor.nodePink.opacity(0.9))
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                        .frame(width: 360, height: 140)
                    }
                    
                    GlassCard {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Recent Designs")
                                .font(.g("Inter-SemiBold", size: 16))
                                .foregroundColor(.white)
                            
                            if sportStore.sports.isEmpty {
                                Text("No recent designs yet.")
                                    .font(.g("Inter-Regular", size: 12))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.top, 8)
                            } else {
                                ForEach(sportStore.sports.suffix(3).reversed()) { sport in
                                    HStack {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(sport.name)
                                                .font(.g("Inter-Medium", size: 14))
                                                .foregroundColor(.white)
                                            Text(sport.summary)
                                                .font(.g("Inter-Regular", size: 11))
                                                .foregroundColor(.white.opacity(0.6))
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white.opacity(0.5))
                                    }
                                    .padding(6)
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.05)))
                                }
                            }
                        }
                        .padding()
                        .frame(width: 260, height: 140)
                    }
                }
                
                // MARK: - Modules Quick Access
                Text("Modules")
                    .font(.g("Inter-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        moduleCard(title: "Field Designer", systemIcon: "square.split.2x2")
                        moduleCard(title: "Rules & Scoring", systemIcon: "list.bullet.rectangle")
                        moduleCard(title: "Team Roles Generator", systemIcon: "person.3.fill")
                        moduleCard(title: "Simulation View", systemIcon: "play.rectangle.fill")
                        moduleCard(title: "Community Vault", systemIcon: "tray.full.fill")
                    }
                    .padding(.vertical, 4)
                }
                
                Spacer(minLength: 30)
            }
            .padding()
        }
    }
    
    // MARK: - Module Card
    @ViewBuilder
    func moduleCard(title: String, systemIcon: String) -> some View {
        GlassCard {
            VStack(spacing: 12) {
                Image(systemName: systemIcon)
                    .font(.system(size: 28))
                    .foregroundColor(MSColor.nodeBlue)
                Text(title)
                    .font(.g("Inter-Medium", size: 14))
                    .foregroundColor(.white)
            }
            .frame(width: 120, height: 120)
            .onTapGesture {
                // Navigate to module view
            }
        }
    }
}

#Preview {
    HomeHubView()
        .environmentObject(SportStore())
}
