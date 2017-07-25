import Foundation
import Result

public func checkout(repo: Repo) -> Result<Repo, SPMRunError> {
    print("Checking out \(repo.ref)...")
    return repo.resolveReference()
               .map(repo.with(resolvedHash:))
               .flatMap({ repo in
                   return launchGit(
                       args: ["checkout", repo.resolvedHash ?? ""],
                       repo: repo
                   ).map({ _ in repo })
               })
}
