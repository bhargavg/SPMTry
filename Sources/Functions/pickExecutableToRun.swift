import Foundation
import Result
import Utilities

public func pickExecutableToRun(list: [URL]) -> Result<URL, SPMRunError> {
    guard let firstExecutable = list.first else {
        return .failure(.tooManyExecutablesFound)
    }

    print("Picked \"\(firstExecutable.lastPathComponent)\" to run")

    return .success(firstExecutable)
}
