import Foundation

var intSigSource: DispatchSourceSignal? = nil
var termSigSource: DispatchSourceSignal? = nil

public func initialize() {
    signal(SIGTERM, ignore)
    signal(SIGINT, ignore)
}

func ignore(_ signal: Int32)  {
    terminateProcessOnExit()
}

func terminateProcessOnExit() {
    /// HACK: https://github.com/Carthage/ReactiveTask/issues/3#issue-50784373
    runningProcess?.terminate()
}

