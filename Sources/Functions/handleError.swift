import Foundation
import Result

public func handle(error: SPMRunError) {
    switch error {
    case let .argumentParseError(err):
        handle(argParseErr: err)
    case .noExecutableFound:
        print("No executable found")
    case .tooManyExecutablesFound:
        print("Morethan one executable found")
    case .unresolvedRepo:
        print("Unresolved Repo")
    case let .binDirError(reason), let .processFailed(reason):
        print("Failed with error: \(reason)")
    }
}

public func handle(argParseErr: ArgParseError) {
    printHelp()
}

public func printHelp() {
    print("Overview: Run remote Swift Package Manager based packages")
    print("                                                         ")
    print("Usage: spmtry username/repo [options]                    ")
    print("       spmtry http[s]://host/username/repo [options]     ")
    print("                                                         ")
    print("Options:                                                 ")
    print("  one of the following options can be provided           ")
    print("                                                         ")
    print("  --branch branchName                                    ")
    print("  --commit hash                                          ")
    print("  --tag [latest | value]                                 ")
}
