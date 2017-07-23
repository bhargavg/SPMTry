import Foundation
import Result
import Utilities

public func ensureBaseDirectoryExists(for repo: Repo) -> Result <Repo, SPMRunError> {
    return ensureDirectoryExists(at: repo.baseDirectory).map({ _ in repo })
}


public func ensureDirectoryExists(at directoryPath: URL) -> Result<URL, SPMRunError> {
    let fileManager = FileManager.default
    if !fileManager.fileExists(atPath: directoryPath.path) {
        do {
            try fileManager.createDirectory(at: directoryPath, withIntermediateDirectories: true)
        } catch {
            return .failure(.binDirError("Cannot create bin directory for this repo"))
        }
    }

    return .success(directoryPath)
}
