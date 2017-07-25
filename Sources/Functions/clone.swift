import Result
import Foundation

public func clone(repo: Repo) -> Result<Repo, SPMRunError> {
    guard !repo.isAlreadyCloned else {
        return .success(repo)
    }

    print("Cloning...")

    return ensureBaseDirectoryExists(
        for: repo
    ).flatMap({ _ in
        return launchGit(
            args: ["clone", repo.remoteURL.absoluteString, repo.checkoutDirectory.path]
        )
    }).map({ _ in
        return repo
    })
}
