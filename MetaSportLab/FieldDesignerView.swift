import SwiftUI


struct FieldDesignerView: View {
    enum ZoneType: String, CaseIterable {
        case neutral, goal, hazard

        var color: Color {
            switch self {
            case .neutral: return MSColor.nodeBlue
            case .goal: return MSColor.nodeYellow
            case .hazard: return MSColor.nodePink
            }
        }

        var label: String {
            switch self {
            case .neutral: return "Neutral"
            case .goal: return "Goal"
            case .hazard: return "Hazard"
            }
        }

        var systemImage: String {
            switch self {
            case .neutral: return "square"
            case .goal: return "flag.checkered"
            case .hazard: return "exclamationmark.triangle"
            }
        }
    }

    struct Zone: Identifiable, Equatable {
        var id = UUID()
        var rect: CGRect
        var type: ZoneType = .neutral
    }

    // MARK: - State
    @State private var gridSize: CGFloat = 24
    @State private var zones: [Zone] = []
    @State private var currentDragRect: CGRect? = nil          // used while drawing new zone
    @State private var selectedZoneID: UUID? = nil
    @State private var isSnapEnabled: Bool = true
    @State private var animerendPlacement: Bool = true

    // For dragging existing zones
    @State private var activeDragZoneID: UUID? = nil
    @State private var dragStartLocation: CGPoint = .zero
    @State private var dragOriginalRect: CGRect = .zero

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Design the Field")
                            .font(.g("Inter-SemiBold", size: 22))
                            .foregroundColor(.white)
                        Text("Draw zones, place goal areas, and define field layout.")
                            .font(.g("Inter-Regular", size: 14))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    // Controls
                    HStack(spacing: 12) {
                        Toggle(isOn: $isSnapEnabled) {
                            Label("Snap", systemImage: isSnapEnabled ? "magnet" : "square")
                                .labelStyle(.iconOnly)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: MSColor.accent))
                        .labelsHidden()
                        
                        Toggle(isOn: $animerendPlacement) {
                            Label("Anim", systemImage: "sparkles")
                                .labelStyle(.iconOnly)
                        }
                        .toggleStyle(SwitchToggleStyle(tint: MSColor.accent))
                        .labelsHidden()
                    }
                }
                .padding(.horizontal)
                
                // Canvas
                ZStack {
                    GeometryReader { geo in
                        let canvasSize = geo.size
                        
                        // Grid
                        Path { path in
                            for x in stride(from: 0, to: canvasSize.width + 1, by: gridSize) {
                                path.move(to: CGPoint(x: x, y: 0))
                                path.addLine(to: CGPoint(x: x, y: canvasSize.height))
                            }
                            for y in stride(from: 0, to: canvasSize.height + 1 , by: gridSize) {
                                path.move(to: CGPoint(x: 0, y: y))
                                path.addLine(to: CGPoint(x: canvasSize.width, y: y))
                            }
                            
                        }
                        .stroke(Color.white.opacity(0.05), lineWidth: 0.6)
                        
                        // Existing zones (render behind gestures)
                        ForEach(zones) { zone in
                            ZoneView(zone: zone,
                                     isSelected: zone.id == selectedZoneID,
                                     onTap: { selectedZoneID = zone.id },
                                     onBeginDrag: { loc in
                                // begin dragging an existing zone
                                activeDragZoneID = zone.id
                                dragStartLocation = loc
                                dragOriginalRect = zone.rect
                            },
                                     onDragChanged: { translation in
                                guard let id = activeDragZoneID,
                                      let idx = zones.firstIndex(where: { $0.id == id }) else { return }
                                var newRect = dragOriginalRect
                                newRect.origin.x += translation.width
                                newRect.origin.y += translation.height
                                
                                if isSnapEnabled {
                                    newRect = snapRectToGrid(newRect, grid: gridSize)
                                }
                                withOptionalAnimation {
                                    zones[idx].rect = newRect
                                }
                            },
                                     onEndDrag: { _ in
                                activeDragZoneID = nil
                            },
                                     onContextMenuDelete: {
                                withAnimation { zones.removeAll { $0.id == zone.id } }
                                if selectedZoneID == zone.id { selectedZoneID = nil }
                            },
                                     onContextMenuChangeType: { newType in
                                if let idx = zones.firstIndex(where: { $0.id == zone.id }) {
                                    withAnimation { zones[idx].type = newType }
                                }
                            })
                            .position(x: zone.rect.midX, y: zone.rect.midY)
                            .frame(width: zone.rect.width, height: zone.rect.height)
                        }
                        
                        // Current drawing rect
                        if let drawing = currentDragRect {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(MSColor.nodeYellow.opacity(0.95), lineWidth: 2)
                                .background(RoundedRectangle(cornerRadius: 6).fill(MSColor.nodeYellow.opacity(0.12)))
                                .frame(width: drawing.width, height: drawing.height)
                                .position(x: drawing.midX, y: drawing.midY)
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                    } // GeometryReader
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.03)))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    .gesture(drawingGesture)
                    
                } // ZStack
                .frame(height: 200)
                .padding(.horizontal)
                
                // Bottom controls
                HStack(spacing: 14) {
                    Button(action: { withAnimation { zones.removeAll(); selectedZoneID = nil } }) {
                        Label("Clear", systemImage: "trash")
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.06)))
                    }
                    
                    Spacer()
                    
                    Stepper("Grid: \(Int(gridSize))", value: $gridSize, in: 12...64, step: 4)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                // Selected zone quick actions
                if let selID = selectedZoneID,
                   let selIndex = zones.firstIndex(where: { $0.id == selID }) {
                    let selZone = zones[selIndex]
                    HStack(spacing: 12) {
                        RuleNodeView(title: selZone.type.label, color: selZone.type.color, systemImage: selZone.type.systemImage, size: 36)
                        Text("Selected: \(Int(selZone.rect.width))×\(Int(selZone.rect.height))")
                            .font(.g("Inter-Regular", size: 13))
                            .foregroundColor(.white.opacity(0.85))
                        Spacer()
                        Button { // cycle type
                            let next = ZoneType.allCases[(ZoneType.allCases.firstIndex(of: selZone.type)! + 1) % ZoneType.allCases.count]
                            withAnimation { zones[selIndex].type = next }
                        } label: {
                            Label("Type", systemImage: "arrow.triangle.2.circlepath")
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.04)))
                        }
                        Button {
                            withAnimation { zones.remove(at: selIndex); selectedZoneID = nil }
                        } label: {
                            Label("Delete", systemImage: "trash")
                                .padding(8)
                                .background(RoundedRectangle(cornerRadius: 8).fill(Color.red.opacity(0.12)))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.02)))
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 0)
            }
            .padding(.vertical)
        }
    }

    // MARK: - Subviews & Helpers

    @ViewBuilder
    private func ZoneView(
        zone: Zone,
        isSelected: Bool,
        onTap: @escaping () -> Void,
        onBeginDrag: @escaping (CGPoint) -> Void,
        onDragChanged: @escaping (CGSize) -> Void,
        onEndDrag: @escaping (DragGesture.Value) -> Void,
        onContextMenuDelete: @escaping () -> Void,
        onContextMenuChangeType: @escaping (ZoneType) -> Void
    ) -> some View {
        let base = RoundedRectangle(cornerRadius: 8)
        ZStack {
            base
                .fill(zone.type.color.opacity(0.14))
                .overlay(base.stroke(zone.type.color.opacity(isSelected ? 0.95 : 0.6), lineWidth: isSelected ? 3 : 2))
                .shadow(color: Color.black.opacity(isSelected ? 0.35 : 0.18), radius: isSelected ? 8 : 4, x: 0, y: 4)

            VStack {
                HStack {
                    Image(systemName: zone.type.systemImage)
                        .font(.system(size: 12))
                        .foregroundColor(zone.type.color)
                    Text(zone.type.label)
                        .font(.g("Inter-SemiBold", size: 12))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(8)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        // Drag for moving existing zone
        .gesture(DragGesture(minimumDistance: 1)
                    .onChanged { val in
                        onDragChanged(val.translation)
                    }
                    .onEnded { val in
                        onEndDrag(val)
                    }
                    .onChanged { _ in } // keep gesture active
        )
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.35).onEnded { _ in 
            onBeginDrag(.zero)
        })
        .contextMenu {
            Button(role: .destructive) { onContextMenuDelete() } label: { Label("Delete Zone", systemImage: "trash") }
            ForEach(ZoneType.allCases, id: \.self) { t in
                Button { onContextMenuChangeType(t) } label: { Label(t.label, systemImage: t.systemImage) }
            }
        }
        .transition(.scale.combined(with: .opacity))
    }

    private func snapValue(_ v: CGFloat, grid: CGFloat) -> CGFloat {
        guard isSnapEnabled else { return v }
        return (v / grid).rounded() * grid
    }

    private func snapRectToGrid(_ r: CGRect, grid: CGFloat) -> CGRect {
        guard isSnapEnabled else { return r }
        let x = snapValue(r.origin.x, grid: grid)
        let y = snapValue(r.origin.y, grid: grid)
        let w = max(grid, snapValue(r.size.width, grid: grid))
        let h = max(grid, snapValue(r.size.height, grid: grid))
        return CGRect(x: x, y: y, width: w, height: h)
    }

    private func withOptionalAnimation(_ updates: @escaping () -> Void) {
        if animerendPlacement {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7, blendDuration: 0.1)) { updates() }
        } else {
            updates()
        }
    }

    // MARK: - Drawing Gesture (create new zones)
    private var drawingGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                // We compute rect in the local coordinate of the GeometryReader.
                // startLocation and location are in global coords relative to the view; we will accept them as-is because the overlay padding is constant.
                let start = value.startLocation
                let current = value.location

                let x = min(start.x, current.x)
                let y = min(start.y, current.y)
                let w = abs(current.x - start.x)
                let h = abs(current.y - start.y)

                var rect = CGRect(x: x, y: y, width: w, height: h)

                if isSnapEnabled {
                    rect = snapRectToGrid(rect, grid: gridSize)
                }

                // update preview rect
                currentDragRect = rect
            }
            .onEnded { value in
                defer { currentDragRect = nil }
                guard let rect = currentDragRect else { return }
                // ignore very small draws
                guard rect.width > 8, rect.height > 8 else { return }

                var newZone = Zone(rect: rect, type: .neutral)
                if isSnapEnabled { newZone.rect = snapRectToGrid(newZone.rect, grid: gridSize) }

                if animerendPlacement {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                        zones.append(newZone)
                    }
                } else {
                    zones.append(newZone)
                }
                // auto-select the new zone
                selectedZoneID = newZone.id
            }
    }

    // Note: For moving existing zones we update the array directly inside the ZoneView closures.
    // The ZoneView invokes onBeginDrag / onDragChanged / onEndDrag to update the zone rect.
    //
    // But because ZoneView cannot detect parent geometry's absolute coordinates easily here, we rely on
    // translations of the DragGesture to shift the original rect. We maintain dragOriginalRect at the start
    // of a drag and apply translations to compute new rects (see how ZoneView is wired in the ForEach).
}

 
struct FieldDesignerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            MSColor.background.ignoresSafeArea()
            FieldDesignerView()
        }
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
 
