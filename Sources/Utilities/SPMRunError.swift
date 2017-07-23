public enum SPMRunError: Error {
    case argumentParseError(ArgParseError)
    case processFailed(String)
    case binDirError(String)
    case unresolvedRepo
    case noExecutableFound
    case tooManyExecutablesFound
}

public enum ArgParseError: Error {
    case invalidArguments
    case invalidURL
}
