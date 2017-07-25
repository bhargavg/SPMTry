import Foundation
import Result

public func handle(_ result: Result<String, SPMRunError>) {
    switch result {
    case let .success(output):
        print(output)
    case let .failure(err):
        handle(error: err)
    }
}

