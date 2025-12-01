import SwiftUI

struct TeamRolesGeneratorView: View {
    @State private var roles: [TeamRoleNode] = [
        TeamRoleNode(title: "Striker"),
        TeamRoleNode(title: "Anchor"),
        TeamRoleNode(title: "Runner"),
        TeamRoleNode(title: "Jammer"),
        TeamRoleNode(title: "Tactician")
    ]
    
    @State private var showColorPickerForRole: UUID? = nil
    @State private var showIconPickerForRole: UUID? = nil
    
    let systemIcons = ["person.fill", "figure.walk", "flag.fill", "star.fill", "shield.fill"]
    let colorPalette: [Color] = [
        MSColor.nodeBlue, MSColor.nodePink, MSColor.nodeYellow, MSColor.accent, Color(hex: "#00FFBD")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Team Roles Generator")
                    .font(.g("Inter-SemiBold", size: 22))
                    .foregroundColor(.white)
                    .padding(.bottom, 6)
                
                Text("Generate and customize your team roles with colors and icons.")
                    .font(.g("Inter-Regular", size: 14))
                    .foregroundColor(.white.opacity(0.8))
                
                VStack(spacing: 12) {
                    ForEach($roles) { $role in
                        roleCard(role: $role)
                    }
                }
                
                Button(action: addRole) {
                    Label("Add Role", systemImage: "plus.circle.fill")
                        .font(.g("Inter-SemiBold", size: 16))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(MSColor.nodePink.opacity(0.8)))
                        .foregroundColor(.black)
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
    
    // MARK: - Role Card
    @ViewBuilder
    func roleCard(role: Binding<TeamRoleNode>) -> some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: role.wrappedValue.icon)
                    .foregroundColor(role.wrappedValue.color)
                    .font(.system(size: 20))
                    .onTapGesture {
                        withAnimation { showIconPickerForRole = role.wrappedValue.id }
                    }
                
                TextField("Role Name", text: role.title)
                    .font(.g("Inter-Regular", size: 15))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    withAnimation {
                        roles.removeAll { $0.id == role.wrappedValue.id }
                    }
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            
            if showColorPickerForRole == role.wrappedValue.id {
                colorPickerGrid(selectedColor: role.color) { newColor in
                    role.color.wrappedValue = newColor
                }
            }
            
            if showIconPickerForRole == role.wrappedValue.id {
                iconPickerGrid(selectedIcon: role.icon) { newIcon in
                    role.icon.wrappedValue = newIcon
                }
            }
        }
        .padding()
        .background(GlassCard { EmptyView() })
    }
    
    // MARK: - Color Picker Grid
    @ViewBuilder
    func colorPickerGrid(selectedColor: Binding<Color>, action: @escaping (Color) -> Void) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
            ForEach(colorPalette, id: \.self) { col in
                Circle()
                    .fill(col)
                    .frame(width: 28, height: 28)
                    .overlay(Circle().stroke(selectedColor.wrappedValue == col ? Color.white.opacity(0.9) : Color.clear, lineWidth: 2))
                    .onTapGesture {
                        withAnimation { action(col) }
                    }
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Icon Picker Grid
    @ViewBuilder
    func iconPickerGrid(selectedIcon: Binding<String>, action: @escaping (String) -> Void) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 8) {
            ForEach(systemIcons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(selectedIcon.wrappedValue == icon ? MSColor.nodeBlue : .white)
                    .padding(6)
                    .background(RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(selectedIcon.wrappedValue == icon ? 0.15 : 0)))
                    .onTapGesture {
                        withAnimation { action(icon) }
                    }
            }
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Add Role
    func addRole() {
        withAnimation {
            roles.append(TeamRoleNode(title: "New Role"))
        }
    }
}

// MARK: - TeamRoleNode Model
struct TeamRoleNode: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var color: Color
    
    init(title: String, icon: String = "person.fill", color: Color = MSColor.nodePink) {
        self.title = title
        self.icon = icon
        self.color = color
    }
}


// MARK: - GlassCard Helper
// Simple glass background style
struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.08))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        .blur(radius: 0.5)
                )
            content
                .padding(14)
        }
        .compositingGroup()
        .shadow(color: Color.black.opacity(0.25), radius: 12, x: 0, y: 6)
    }
}


#Preview {
    TeamRolesGeneratorView()
}
