import Foundation
import Result

public func launchGit(
    args: [String],
    repo: Repo? = nil,
    interactive: Bool = false
) -> Result<String, SPMRunError> {

    let arguments: [String]
    if let repo = repo {
        let commonGitArgs = [
            "-C", repo.checkoutDirectory.path
        ]
        arguments = commonGitArgs + args
    } else {
        arguments = args
    }

    let gitPath = "/usr/bin/git"

    if interactive {
        return launchInteractiveProcess(
            path: gitPath,
            args: arguments
        ).map({ _ in "" })
    } else {
        return launchProcess(
            path: gitPath,
            args: arguments
        )
    }
}

