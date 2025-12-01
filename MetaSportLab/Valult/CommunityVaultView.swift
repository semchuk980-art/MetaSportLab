import SwiftUI
import UniformTypeIdentifiers

struct CommunityVaultView: View {
    @EnvironmentObject var sportStore: SportStore      // Your app’s store
    @State private var shareItem: URL? = nil
    @State private var importPresented = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Community Vault")
                .font(.g("Inter-SemiBold", size: 22))
                .foregroundColor(.white)

            Text("Local-only storage. Export your imaginary sports and share them offline.")
                .font(.g("Inter-Regular", size: 13))
                .foregroundColor(.white.opacity(0.8))
                .padding(.bottom, 8)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(sportStore.sports) { sport in
                        vaultCard(for: sport)
                    }
                }
                .padding(.vertical, 4)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .fileImporter(
            isPresented: $importPresented,
            allowedContentTypes: [.json]
        ) { result in
            handleImport(result)
        }
        .sheet(isPresented: Binding<Bool>(
            get: { shareItem != nil },
            set: { if !$0 { shareItem = nil } }
        )) {
            if let item = shareItem {
                ShareSheet(activityItems: [item])
            }
        }

    }

    // MARK: - Card View
    @ViewBuilder
    func vaultCard(for sport: SportModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(sport.name)
                        .font(.g("Inter-SemiBold", size: 18))
                        .foregroundColor(.white)

                    Text(sport.summary)
                        .font(.g("Inter-Regular", size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()

                Menu {
                    Button {
                        exportSport(sport)
                    } label: {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }

                    Button(role: .destructive) {
                        deleteSport(sport)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.white.opacity(0.9))
                }
            }

            Divider().background(.white.opacity(0.1))

            HStack(spacing: 20) {
                iconInfo("figure.soccer", "\(sport.rules.count) rules")
                iconInfo("square.grid.3x3", "\(sport.fieldLayout.count) zones")
                iconInfo("person.3", "\(sport.roles.count) roles")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.white.opacity(0.05))
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .blur(radius: 0.5)
        )
        .padding(.horizontal, 2)
    }

    @ViewBuilder
    func iconInfo(_ system: String, _ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: system)
                .foregroundColor(MSColor.nodeBlue)
            Text(text)
                .font(.g("Inter-Regular", size: 12))
                .foregroundColor(.white.opacity(0.8))
        }
    }

    // MARK: - Actions
    func deleteSport(_ sport: SportModel) {
        withAnimation(.easeInOut) {
            sportStore.sports.removeAll { $0.id == sport.id }
        }
    }

    func exportSport(_ sport: SportModel) {
        do {
            let data = try JSONEncoder().encode(sport)
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(sport.name).json")
            try data.write(to: url)
            shareItem = url
        } catch { print("Export failed:", error) }
    }

    func handleImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let fileURL):
            do {
                let data = try Data(contentsOf: fileURL)
                let sport = try JSONDecoder().decode(SportModel.self, from: data)
                sportStore.sports.append(sport)
            } catch {
                print("Import failed:", error)
            }
        case .failure(let error):
            print("Import error:", error)
        }
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}


#Preview {
    CommunityVaultView()
}
