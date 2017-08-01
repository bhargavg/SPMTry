import Foundation
import Result

public func runExecutable(at execPath: URL, args: [String]) -> Result<String, SPMRunError> {
    print("Running \"\(execPath.lastPathComponent)\" (use Ctrl+C to terminate) ")
    return launchInteractiveProcess(
        path: execPath.path,
        args: args
    ).map({ _ in "" })
}
