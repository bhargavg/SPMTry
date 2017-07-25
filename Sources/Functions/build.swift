import Foundation
import Result


public func build(repo: Repo) -> Result<Repo, SPMRunError> {
    guard !repo.isAlreadyBuilt else {
        return .success(repo)
    }

    print("Building the project...")

    return repo.binDirectory
               .flatMap(ensureDirectoryExists(at:))
               .flatMap({ binDirectory in
        let arguments: [String] = [
            "build",
            "--chdir", repo.checkoutDirectory.path,
            "--build-path", binDirectory.path
        ]

        return launchProcess(
            path: "/usr/bin/swift",
            args: arguments
        ).map({ _ in
            return repo
        })
    })
}

