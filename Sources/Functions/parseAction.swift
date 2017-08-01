import Foundation
import Result

public enum Action {
    case showHelp
    case repo(Repo, [String])
}

public func parseAction(arguments: [String]) -> Result<Action, ArgParseError> {
    let parser = ArgumentParser(args: Array(arguments.dropFirst(1)))

    if parser.consumeFlag(short: "h", long: "help") != nil {
        return .success(.showHelp)
    } else {
        guard let rawURL = parser.consumeValue(at: 0) else {
            return .failure(.invalidArguments)
        }

        guard let parsedURL = URL.from(arg: rawURL).value else {
            return .failure(.invalidArguments)
        }

        let rawBranch = parser.consumeOption(short: "b", long: "branch")
        let rawTag = parser.consumeOption(short: "t", long: "tag")
        let rawCommit = parser.consumeOption(short: "c", long: "commit")

        guard !parser.hasOptionsToParse else {
            print(parser.args)
            return .failure(.invalidArguments)
        }

        let ref: Repo.Reference
        switch (rawBranch, rawTag, rawCommit) {
        case let (.some(name), .none, .none):
            ref = .branch(name)
        case let (.none, .some(name), .none):
            ref = .tag(.absolute(name))
        case let (.none, .none, .some(hash)):
            ref = .commit(hash)
        case (.none, .none, .none):
            ref = .tag(.latest)
        default:
            return .failure(.invalidArguments)
        }

        let base = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(".spm")

        return .success(.repo(Repo(
            remoteURL: parsedURL,
            ref: ref,
            baseDirectory: base
        ), parser.additionalArgs))
    }
}


final class ArgumentParser {
    private(set) var args: [String]
    let additionalArgs: [String]

    var hasOptionsToParse: Bool {
        return !args.isEmpty
    }

    init(args: [String]) {
        let split = args.split(separator: "--")

        self.args = split.indices.contains(0) ? Array(split[0]) : []
        self.additionalArgs = split.indices.contains(1) ? Array(split[1]) : []
    }

    public func consumeValue(at index: Int) -> String? {
        guard args.indices.contains(index) else {
            return nil
        }

        guard !args[index].isOption else {
            return nil
        }

        return args.remove(at: index)
    }

    public func consumeOption(short: String, long: String) -> String? {
        guard let optionIndex = consumeFlag(short: short, long: long) else {
            return nil
        }

        let valueIndex = optionIndex
        return consumeValue(at: valueIndex)
    }

    public func consumeFlag(short: String, long: String) -> Int? {
        guard let index = indexOfFlag(short: short, long: long) else {
            return nil
        }

        args.remove(at: index)

        return index
    }

    private func indexOfFlag(short: String,  long: String) -> Int? {
        let shortIndex = args.index(of: "-" + short)
        let longIndex  = args.index(of: "--" + long)

        if shortIndex != nil, longIndex != nil {
            /// Both short and long versions are present
            return nil
        }

        guard let index = (shortIndex ?? longIndex) else {
            /// none of the options are present
            return nil
        }

        return index
    }
}

fileprivate extension String {
    var isOption: Bool {
        return hasPrefix("-")
    }
}

