// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftCodeApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .executable(name: "SwiftCodeApp", targets: ["App"])
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [],
            path: "Sources/App",
            resources: [.process("Assets.xcassets")]
        )
    ]
)
