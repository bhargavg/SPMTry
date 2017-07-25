import Foundation
import Result

public func launchGit(
    args: [String],
    repo: Repo? = nil
) -> Result<String, SPMRunError> {

    let arguments: [String]
    if let repo = repo {
        arguments = commonGitArgs(for: repo) + args
    } else {
        arguments = args
    }

    let gitPath = "/usr/bin/git"

    return launchProcess(
        path: gitPath,
        args: arguments
    ).map({ $0.trimmingCharacters(in: .whitespacesAndNewlines) })
}

func commonGitArgs(for repo: Repo) -> [String] {
    return [
        "-C", repo.checkoutDirectory.path,
    ]
}

