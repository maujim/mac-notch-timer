// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MacNotchTimer",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "MacNotchTimer", targets: ["MacNotchTimer"]),
        .library(name: "MacNotchTimerSupport", targets: ["MacNotchTimerSupport"])
    ],
    targets: [
        .target(
            name: "MacNotchTimerSupport",
            path: "Sources/MacNotchTimerSupport"
        ),
        .executableTarget(
            name: "MacNotchTimer",
            dependencies: ["MacNotchTimerSupport"],
            path: "Sources/MacNotchTimer"
        ),
        .testTarget(
            name: "MacNotchTimerSupportTests",
            dependencies: ["MacNotchTimerSupport"],
            path: "Tests/MacNotchTimerSupportTests"
        )
    ]
)
