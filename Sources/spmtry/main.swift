import Foundation
import Result
import Functions

initialize()

let result = parseAction(
   arguments: CommandLine.arguments
).mapError({ SPMRunError.argumentParseError($0) })
 .flatMap(perform(action:))


handle(result)

