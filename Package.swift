// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LVModalQueue",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "LVModalQueue",
            targets: ["LVModalQueue"]
        )
    ],
    targets: [
        .target(
            name: "LVModalQueue",
            path: "Sources/LVModalQueue",
            publicHeadersPath: "include"
        )
    ]
)
