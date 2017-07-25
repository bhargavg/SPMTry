import Foundation
import Result
import Yams

public func findExecutables(for repo: Repo) -> Result<[URL], SPMRunError> {
    print("Getting list of executables...")
    return repo.binDirectory.map({ 
        $0.appendingPathComponent("debug.yaml") 
    }).flatMap({ 
        findExecutables(yamlPath: $0, repo: repo)
    })
}

func findExecutables(yamlPath: URL, repo: Repo) -> Result<[URL], SPMRunError> {
    guard let mayBeCommands = try? compose(yaml: String(contentsOfFile: yamlPath.path, encoding: .utf8))?["commands"],
          let commands = mayBeCommands?.mapping else {
        return .failure(.noExecutableFound)
    }

    let executableURLs = commands.filter({
        return $0.key.string?.hasSuffix(".exe>") ?? false
    }).flatMap({
        $0.value.mapping?["outputs"]?.array().first ?? ""
    }).map(URL.init(fileURLWithPath:))

    guard !executableURLs.isEmpty else {
        return .failure(.noExecutableFound)
    }

    return .success(executableURLs)
}
