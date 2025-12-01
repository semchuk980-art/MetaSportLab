import SwiftUI

// MARK: - SPORT MODEL
struct SportModel: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var summary: String

    // Field designer zones
    var fieldLayout: [FieldZone]

    // Rules & scoring
    var rules: [SportRule]

    // Roles
    var roles: [TeamRole]

    init(
        id: UUID = UUID(),
        name: String,
        summary: String = "",
        fieldLayout: [FieldZone] = [],
        rules: [SportRule] = [],
        roles: [TeamRole] = []
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.fieldLayout = fieldLayout
        self.rules = rules
        self.roles = roles
    }
}

// MARK: - ZONE MODEL
struct FieldZone: Identifiable, Codable, Equatable {
    let id: UUID
    var rect: CGRect
    var type: ZoneType

    init(id: UUID = UUID(), rect: CGRect, type: ZoneType = .neutral) {
        self.id = id
        self.rect = rect
        self.type = type
    }
}

enum ZoneType: String, Codable, CaseIterable {
    case goal
    case hazard
    case neutral
}

// MARK: - RULE MODEL
struct SportRule: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var details: String

    init(id: UUID = UUID(), title: String, details: String = "") {
        self.id = id
        self.title = title
        self.details = details
    }
}

// MARK: - TEAM ROLE MODEL
struct TeamRole: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String

    init(id: UUID = UUID(), name: String, description: String = "") {
        self.id = id
        self.name = name
        self.description = description
    }
}
