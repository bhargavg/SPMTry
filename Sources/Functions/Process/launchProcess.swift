import Foundation
import Result

func launchProcess(
   path: String,
   args: [String]
) -> Result<String, SPMRunError> {

    let group = DispatchGroup()

    let process = Process()
    process.launchPath = path
    process.arguments = args

    var execOutData = Data()
    let execOutPipe = Pipe()
    process.standardOutput = execOutPipe

    execOutPipe.fileHandleForReading.readabilityHandler = { handle in
        execOutData.append(handle.availableData)
    }

    var execErrData = Data()
    let execErrPipe = Pipe()
    process.standardError = execErrPipe

    execErrPipe.fileHandleForReading.readabilityHandler = { handle in
        execErrData.append(handle.availableData)
    }

    var result: Result<String, SPMRunError> = .failure(.processFailed(.unknown))
    process.terminationHandler  = { (process) in
        if process.terminationStatus == EXIT_SUCCESS {
            result = .success(string(fromOutput: execOutData))
        } else {
            result = .failure(
                .processFailed(
                    .error(
                        code: process.terminationStatus,
                        message: string(fromOutput: execErrData)
                    )
                )
            )
        }

        runningProcess = nil
        group.leave()
    }


    group.enter()
    process.launch()
    runningProcess = process
    group.wait()

    return result
}

fileprivate func string(fromOutput data: Data) -> String {
    return String(
        data: data,
        encoding: .utf8
    )?.trimmingCharacters(
        in: .whitespacesAndNewlines
    ) ?? ""
}
