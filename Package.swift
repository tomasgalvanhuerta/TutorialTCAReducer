// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TutorialTCAReducer",
    products: [
        .library(
            name: "TutorialTCAReducer",
            targets: ["TutorialTCAReducer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git" , from: .init(1, 0, 0)),
        
    ],
    targets: [
        .target(
            name: "TutorialTCAReducer"),
        .testTarget(
            name: "TutorialTCAReducerTests",
            dependencies: ["TutorialTCAReducer"]
        ),
    ]
)
