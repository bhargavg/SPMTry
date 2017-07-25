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

    // Get the data
    let processStdOut = stdOutPipe.fileHandleForReading
    let processStdErr = stdErrPipe.fileHandleForReading
    let output = String(data: processStdOut.readDataToEndOfFile(), encoding: .utf8)
    let error  = String(data: processStdErr.readDataToEndOfFile(), encoding: .utf8)

    defer {
        processStdOut.closeFile()
        processStdErr.closeFile()
    }

    guard task.terminationStatus == 0 else {
        return .failure(.processFailed(error ?? ""))
    }

    return .success(output ?? "")
}

