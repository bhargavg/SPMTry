// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "spmtry",
    targets: [
        Target(name: "spmtry", dependencies: ["Functions"]),
        Target(name: "Functions", dependencies: ["CCommonCrypto"]),
        Target(name: "CCommonCrypto", dependencies: []),
    ],
    dependencies: [
        .Package(url: "https://github.com/antitypical/Result.git", Version(3, 2, 3)),
        .Package(url: "https://github.com/jpsim/Yams.git", Version(0, 3, 3))
    ]
)
