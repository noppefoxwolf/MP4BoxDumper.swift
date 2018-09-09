// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MP4BoxDumper",
    dependencies: [],
    targets: [
        .target(
            name: "MP4BoxDumper",
            dependencies: ["Core"]),
        .target(
          name: "Core",
          dependencies: []),
        .testTarget(
          name: "CoreTests",
          dependencies: ["Core"],
          path: "Tests/CoreTests")
    ]
)
