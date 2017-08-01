import Foundation

extension DispatchData {
    var asData: Data {
        let bytes = UnsafeMutablePointer<UInt8>.allocate(capacity: count)
        copyBytes(to: bytes, count: count)
        let data = Data(bytes: bytes, count: count)
        bytes.deinitialize(count: count)
        bytes.deallocate(capacity: count)

        return data
    }
}
