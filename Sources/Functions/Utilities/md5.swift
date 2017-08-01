import Foundation
import CCommonCrypto

/// Source: https://stackoverflow.com/a/32166735
public func md5(string: String) -> Data {
    let messageData = string.data(using:.utf8)!
    var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))

    _ = digestData.withUnsafeMutableBytes {digestBytes in
        messageData.withUnsafeBytes {messageBytes in
            CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
        }
    }

    return digestData
}

public extension String {
    var md5Hex: String {
        return md5(
            string: self
        ).map({ String(format: "%02hhx", $0) })
         .joined()
    }
}
