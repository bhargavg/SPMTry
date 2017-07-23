import Foundation
import Result
import Utilities

public func checkout(repo: Repo) -> Result<Repo, SPMRunError> {
    print("Checking out...")
    return repo.resolveReference()
               .map(repo.with(resolvedHash:))
               .flatMap({ repo in
                   return launchGit(
                       args: ["checkout", repo.resolvedHash ?? ""],
                       repo: repo
                   ).map({ _ in repo })
               })
}
