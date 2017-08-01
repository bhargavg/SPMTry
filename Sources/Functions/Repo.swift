import Foundation
import Result

public struct Repo {
    public let remoteURL: URL
    public let ref: Reference
    public let resolvedHash: String?
    public let baseDirectory: URL

    public var isAlreadyBuilt: Bool {
        guard let exists = binDirectory.map({ FileManager.default.fileExists(atPath: $0.path) }).value else {
            return false
        }

        return exists
    }

    public var isAlreadyCloned: Bool {
        return FileManager.default.fileExists(atPath: checkoutDirectory.path)
    }

    public var checkoutDirectory: URL {
        let host = remoteURL.host ?? ""
        let nestedDirNames = ([host] + remoteURL.pathComponents).filter({ !$0.isEmpty && $0 != "/" })
        let root = baseDirectory.appendingPathComponent("checkouts")

        return nestedDirNames.reduce(root) { path, component in
            path.appendingPathComponent(component)
        }
    }

    public var binDirectory: Result<URL, SPMRunError> {
        guard let resolvedHash = resolvedHash else {
            return .failure(.unresolvedRepo)
        }
        return .success(baseDirectory.appendingPathComponent("bin")
                                     .appendingPathComponent(resolvedHash))
    }

    public enum Reference {
        case commit(String)
        case branch(String)
        case tag(Version)

        static let `default`: Reference = .tag(.latest)
    }

    public enum Version {
        case latest
        case absolute(String)
    }

    public init(
        remoteURL: URL,
        ref: Reference,
        baseDirectory: URL,
        resolvedHash: String? = nil
    ) {
        self.remoteURL = remoteURL
        self.ref = ref
        self.baseDirectory = baseDirectory
        self.resolvedHash = resolvedHash
    }

    public func with(resolvedHash hash: String) -> Repo {
        return Repo(
            remoteURL: remoteURL,
            ref: ref,
            baseDirectory: baseDirectory,
            resolvedHash: hash
        )
    }

    public func resolveReference() -> Result<String, SPMRunError> {
        return getHash().recover(with:
            fetchRemote().flatMap({ _ in
                getHash()
            })
        )
    }

    private func getHash() -> Result<String, SPMRunError> {
        switch ref {
        case let .commit(hash):
            return .success(hash)
        case let .branch(name):
            return launchGit(
                args: ["rev-parse", "--verify", name],
                repo: self
            ).mapError({ _ in .unresolvedRepo })
        case let .tag(.absolute(tagName)):
            return launchGit(
                args: ["rev-parse", "--verify", "\(tagName)^{commit}"],
                repo: self
            ).mapError({ _ in .unresolvedRepo })
        case .tag(.latest):
            return launchGit(
                args: ["describe", "--tags"],
                repo: self
            ).mapError({ _ in .unresolvedRepo })
             .flatMap({ latestTagName in
                return launchGit(
                    args: ["rev-parse", "--verify", "\(latestTagName)^{commit}"],
                    repo: self
                ).mapError({ _ in .unresolvedRepo })
            })
        }
    }

    private func fetchRemote() -> Result<String, SPMRunError> {
        switch ref {
        case .commit, .branch:
            return launchGit(
                args: ["fetch", "--all"],
                repo: self
            )
        case .tag:
            return launchGit(
                args: ["fetch", "--tags", "--force"],
                repo: self
            )
        }
    }
}

extension Repo.Reference: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .commit(hash):
            return "commit: \(hash)"
        case let .branch(name):
            return "branch: \(name)"
        case .tag(.latest):
            return "tag: latest"
        case let .tag(.absolute(tagName)):
            return "tag: \(tagName)"
        }
    }
}


extension URL {
    static func from(arg: String) -> Result<URL, ArgParseError> {
        /// FIXME: this is not supported because, as of now, we can't
        /// parse this URL
        guard !arg.hasPrefix("git@") else {
            return .failure(.invalidURL)
        }
        
        guard !arg.isEmpty else {
            return .failure(.invalidURL)
        }

        guard var components = URLComponents(string: arg) else {
            return .failure(.invalidURL)
        }

        let baseURL = (components.host == nil) ? URL(string: "https://github.com") : nil

        return Result(
            components.url(relativeTo: baseURL),
            failWith: .invalidURL
        )
    }

    var md5Hex: String {
        return absoluteString.md5Hex
    }
}

