import Foundation
import Result

func launchInteractiveProcess(
   path: String,
   args: [String]
) -> Result<Bool, SPMRunError> {

    let group = DispatchGroup()

    let process = Process()
    process.launchPath = path
    process.arguments = args

    var result: Result<Bool, SPMRunError> = .failure(.processFailed(.unknown))
    process.terminationHandler  = { (process) in
        if process.terminationStatus == EXIT_SUCCESS {
            result = .success(true)
        } else {
            result = .failure(
                .processFailed(
                    .error(
                        code: process.terminationStatus,
                        message: ""
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

