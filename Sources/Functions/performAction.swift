import Foundation
import Result

public func perform(action: Action) -> Result<String, SPMRunError> {
     switch action {
     case .showHelp:
        printHelp()
        return .success("")
     case let .repo(repo, execArgs):
        return clone(
            repo: repo
        ).flatMap(checkout(repo:))
         .flatMap(build(repo:))
         .flatMap(findExecutables(for:))
         .flatMap(pickExecutableToRun(list:))
         .flatMap({ runExecutable(at: $0, args: execArgs) })
     }
}
