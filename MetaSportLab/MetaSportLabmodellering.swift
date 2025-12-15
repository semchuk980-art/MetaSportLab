import Foundation
 
final class MetaSportLabmodellering {
    func MetaSportLabDataEnc(snaar: String) -> String? {
        let transformed = snaar.unicodeScalars.map { scalar -> UInt32 in
            return scalar.value + 3
        }
        let encrypted = transformed.map { String(UnicodeScalar($0)!) }.joined()
        return encrypted
    }
 
    func MetaSportLabDecData(snaar: String) -> String? {
        let transformed = snaar.unicodeScalars.map { scalar -> UInt32 in
            return scalar.value - 3
        }
        let decrypted = transformed.map { String(UnicodeScalar($0)!) }.joined()
        return decrypted
    }
}
