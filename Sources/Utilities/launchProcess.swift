import Foundation
import Result

public func launchProcess(path: String, args: [String]) -> Result<String, SPMRunError> {
    let task = Process()

    task.launchPath = path
    task.arguments = args

    let stdOutPipe = Pipe()
    task.standardOutput = stdOutPipe

    let stdErrPipe = Pipe()
    task.standardError = stdErrPipe

    task.launch()
    task.waitUntilExit()

    // Get the data
    let stdOutData = stdOutPipe.fileHandleForReading.readDataToEndOfFile()
    let stdErrData = stdErrPipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: stdOutData, encoding: .utf8)
    let error  = String(data: stdErrData, encoding: .utf8)

    guard task.terminationStatus == 0 else {
        return .failure(.processFailed(error ?? ""))
    }

    return .success(output ?? "")
}

