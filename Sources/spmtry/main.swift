import Foundation
import Functions
import Utilities


let result = parse(
   arguments: CommandLine.arguments
).mapError({ SPMRunError.argumentParseError($0) })
 .flatMap(clone(repo:))
 .flatMap(checkout(repo:))
 .flatMap(build(repo:))
 .flatMap(findExecutables(for:))
 .flatMap(pickExecutableToRun(list:))
 .flatMap(runExecutable(at:))

handle(result)

