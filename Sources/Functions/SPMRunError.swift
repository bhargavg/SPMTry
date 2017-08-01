public enum SPMRunError: Error {
    case argumentParseError(ArgParseError)
    case processFailed(ProcessError)
    case binDirError(String)
    case unresolvedRepo
    case noExecutableFound
    case tooManyExecutablesFound
}

public enum ProcessError {
    case unknown
    case error(code: Int32, message: String?)
}

public enum ArgParseError: Error {
    case invalidArguments
    case invalidURL
}
