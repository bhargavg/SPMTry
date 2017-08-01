import Foundation

extension Data {
    var asString: String? {
        return String(data: self, encoding: .utf8)
    }
}
