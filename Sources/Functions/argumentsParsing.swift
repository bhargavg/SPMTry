import Foundation
import Result

public func parse(arguments: [String]) -> Result<Repo, ArgParseError> {
    let modifiedArgs = (arguments.count == 2) ? arguments + ["--tag", "latest"] : arguments

    guard modifiedArgs.count == 4 else {
        return .failure(.invalidArguments)
    }

    let tagResult: Result<Repo.Reference, ArgParseError>
    switch modifiedArgs[2] {
    case "--tag":
        let version: Repo.Version = (modifiedArgs[3] == "latest") ? .latest : .absolute(modifiedArgs[3])
        tagResult = .success(.tag(version))
    case "--branch":
        tagResult = .success(.branch(modifiedArgs[3]))
    case "--commit":
        tagResult = .success(.commit(modifiedArgs[3]))
    default:
        tagResult = .failure(.invalidArguments)
    }

    let urlResult = URL.from(arg: modifiedArgs[1])

    return urlResult.fanout(
        tagResult
    ).map({ 
        Repo(remoteURL: $0.0, ref: $0.1, baseDirectory: URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".spm"))
    })
}

