import Foundation
import Result

public func runExecutable(at execPath: URL) -> Result<String, SPMRunError> {
    print("Running \"\(execPath.lastPathComponent)\": ")
    return launchProcess(
        path: execPath.path,
        args: []
    )
}
