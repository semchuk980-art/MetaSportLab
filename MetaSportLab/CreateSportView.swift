import SwiftUI

struct CreateSportView: View {
    @State private var sportName: String = ""
    @State private var fieldType: FieldType = .outdoor
    @State private var movementRules: [RuleNode] = []
    @State private var scoringRules: [RuleNode] = []
    @State private var themeColor: Color = MSColor.nodeBlue
    @State private var showColorPicker: Bool = false
    @State private var showSaveAlert: Bool = false
    @EnvironmentObject var sportStore: SportStore

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 26) {

                // TITLE
                Text("Create a Sport")
                    .font(.g("Inter-SemiBold", size: 26))
                    .foregroundColor(.white)
                    .padding(.top, 4)

                // SPORT NAME
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sport Name")
                        .font(.g("Inter-Medium", size: 15))
                        .foregroundColor(.white.opacity(0.85))

                    TextField("Enter sport name...", text: $sportName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                        .foregroundColor(.white)
                        .font(.g("Inter-Regular", size: 15))
                }
                .padding(.horizontal)

                // FIELD TYPE PICKER
                VStack(alignment: .leading, spacing: 6) {
                    Text("Field Type")
                        .font(.g("Inter-Medium", size: 15))
                        .foregroundColor(.white.opacity(0.85))

                    fieldTypePicker
                }
                .padding(.horizontal)

                // MOVEMENT RULES BUILDER
                ruleSection(
                    title: "Movement Rules",
                    systemImage: "figure.walk.motion",
                    rules: $movementRules
                )

                // SCORING RULES BUILDER
                ruleSection(
                    title: "Scoring Rules",
                    systemImage: "trophy",
                    rules: $scoringRules
                )

                // THEME COLOR
                VStack(alignment: .leading, spacing: 6) {
                    Text("Theme Color")
                        .font(.g("Inter-Medium", size: 15))
                        .foregroundColor(.white.opacity(0.85))

                    Button {
                        showColorPicker.toggle()
                    } label: {
                        HStack {
                            Circle()
                                .fill(themeColor)
                                .frame(width: 22, height: 22)

                            Text("Choose Color")
                                .foregroundColor(.white)
                                .font(.g("Inter-Regular", size: 15))

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    }

                    if showColorPicker {
                        colorPickerGrid
                            .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.horizontal)

                // LIVE PREVIEW CARD
                previewCard

                // SAVE BUTTON
                Button(action: saveSport) {
                    Label("Save Sport", systemImage: "checkmark.circle.fill")
                        .font(.g("Inter-SemiBold", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 16).fill(themeColor.opacity(0.9)))
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
        }
        .alert("Sport Saved!", isPresented: $showSaveAlert) {
            Button("Done") { presentationMode.wrappedValue.dismiss() }
        }
    }
}

// MARK: - FIELD TYPE
enum FieldType: String, CaseIterable {
    case outdoor, indoor, custom

    var icon: String {
        switch self {
        case .outdoor: return "leaf"
        case .indoor: return "square.grid.3x3"
        case .custom: return "hammer"
        }
    }

    var label: String {
        rawValue.capitalized
    }
}

extension CreateSportView {
    var fieldTypePicker: some View {
        HStack(spacing: 14) {
            ForEach(FieldType.allCases, id: \.self) { type in
                Button {
                    withAnimation(.spring()) { fieldType = type }
                } label: {
                    HStack {
                        Image(systemName: type.icon)
                            .font(.system(size: 15, weight: .medium))

                        Text(type.label)
                            .font(.g("Inter-Medium", size: 15))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(type == fieldType ? Color.white.opacity(0.18) : Color.white.opacity(0.05))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(type == fieldType ? 0.2 : 0.08), lineWidth: 1)
                    )
                    .foregroundColor(.white)
                }
            }
        }
    }
}

// MARK: - RULE MODEL
struct RuleNode: Identifiable, Equatable {
    var id = UUID()
    var text: String
    var icon: String
}

// MARK: - RULES SECTION
extension CreateSportView {

    func ruleSection(title: String, systemImage: String, rules: Binding<[RuleNode]>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.g("Inter-Medium", size: 15))
                .foregroundColor(.white.opacity(0.85))
                .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(rules.wrappedValue) { rule in
                    ruleRow(rule: rule, rules: rules)
                        .padding(.horizontal)
                }

                // Add Rule Button
                Button {
                    withAnimation(.spring()) {
                        rules.wrappedValue.append(
                            RuleNode(text: "New Rule", icon: systemImage)
                        )
                    }
                } label: {
                    Label("Add Rule", systemImage: "plus.circle")
                        .font(.g("Inter-Regular", size: 15))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
            }
        }
    }

    func ruleRow(rule: RuleNode, rules: Binding<[RuleNode]>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: rule.icon)
                .font(.system(size: 16))
                .foregroundColor(MSColor.nodeBlue)

            TextField("Rule...", text: Binding(
                get: { rule.text },
                set: { newVal in
                    if let idx = rules.wrappedValue.firstIndex(of: rule) {
                        rules.wrappedValue[idx].text = newVal
                    }
                }
            ))
            .font(.g("Inter-Regular", size: 15))
            .foregroundColor(.white)

            Spacer()

            Button {
                withAnimation {
                    rules.wrappedValue.removeAll(where: { $0.id == rule.id })
                }
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white.opacity(0.45))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(Color.white.opacity(0.05)))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08)))
    }
}

// MARK: - COLOR PICKER
extension CreateSportView {
    var colorPickerGrid: some View {
        let palette: [Color] = [
            MSColor.nodeBlue,
            MSColor.nodeYellow,
            MSColor.nodePink,
            MSColor.accent,
            Color(hex: "#00FFBD"),
            Color(hex: "#FF6B00"),
            Color(hex: "#8C52FF"),
            Color(hex: "#ffffff")
        ]

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 8)) {
            ForEach(palette, id: \.self) { col in
                Circle()
                    .fill(col)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(col == themeColor ? 0.9 : 0), lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.spring()) { themeColor = col }
                    }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - PREVIEW CARD
extension CreateSportView {
    var previewCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Sport Preview")
                    .font(.g("Inter-SemiBold", size: 18))
                    .foregroundColor(.white)
                Spacer()
            }

            RoundedRectangle(cornerRadius: 16)
                .fill(themeColor.opacity(0.22))
                .frame(height: 180)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        Text(sportName.isEmpty ? "Unnamed Sport" : sportName)
                            .font(.g("Inter-Bold", size: 20))
                            .foregroundColor(.white)

                        HStack {
                            Image(systemName: fieldType.icon)
                            Text(fieldType.label)
                        }
                        .foregroundColor(.white.opacity(0.75))
                        .font(.g("Inter-Regular", size: 14))

                        Divider().background(Color.white.opacity(0.15))

                        VStack(alignment: .leading, spacing: 6) {
                            Text("Rules: \(movementRules.count + scoringRules.count)")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.g("Inter-Light", size: 12))
                        }

                        Spacer()
                    }
                    .padding(16)
                )
        }
        .padding(.horizontal)
    }
}

// MARK: - SAVE
extension CreateSportView {
    // MARK: - SAVE SPORT
    
    func summaryFromRules() -> String {
        var parts: [String] = []
        if !movementRules.isEmpty { parts.append("\(movementRules.count) movement rules") }
        if !scoringRules.isEmpty { parts.append("\(scoringRules.count) scoring rules") }
        return parts.joined(separator: " • ")
    }

    
    func saveSport() {
        guard !sportName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newSport = SportModel(
            name: sportName,
            summary: summaryFromRules(),
            fieldLayout: [],                 // You will populate from Field Designer later
            rules: movementRules.map { SportRule(title: $0.text) }
                 + scoringRules.map { SportRule(title: $0.text) },
            roles: []
        )

        sportStore.sports.append(newSport)
        showSaveAlert = true
    }

}


#Preview {
    CreateSportView()
}
