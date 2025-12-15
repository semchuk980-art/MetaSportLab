import SwiftUI
import Foundation
import UIKit

@propertyWrapper
struct MetaStandaardLabverpakt<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return defaultValue }
            let value = try? JSONDecoder().decode(T.self, from: data)
            return value ?? defaultValue
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    mutating func reset() {
        wrappedValue = defaultValue
    }
}
final class MetaSportLabverpakt {
    @MetaStandaardLabverpakt(key: "base", defaultValue: "")
    static var base: String
}
