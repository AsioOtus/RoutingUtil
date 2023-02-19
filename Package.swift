// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "RoutingUtil",
  platforms: [.iOS(.v13), .macOS(.v10_15)],
  products: [
    .library(
      name: "RoutingUtil",
      targets: ["RoutingUtil"]),
  ],
  targets: [
    .target(
      name: "RoutingUtil"
    ),
    .executableTarget(
      name: "Testground",
      dependencies: ["RoutingUtil"]
    )
  ]
)
