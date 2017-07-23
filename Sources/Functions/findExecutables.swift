import Foundation
import Result
import Utilities
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
    guard let yaml = try? Yams.compose(yaml: String(contentsOfFile: yamlPath.path, encoding: .utf8)),
          let commands = yaml?["commands"]?.mapping?.values else {
        return .failure(.noExecutableFound)
    }

    let execNames = commands.filter({
        guard let isLibrary = $0["is-library"]?.bool else {
            return false
        }
        return !isLibrary
    }).flatMap({
        $0["module-name"]?.string
    })

    return repo.binDirectory.map({ binDirectory in
        return execNames.map({ execName in
            binDirectory.appendingPathComponent("debug")
                        .appendingPathComponent(execName)
        })
    })
}
