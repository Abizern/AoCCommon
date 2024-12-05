// swift-tools-version: 6.0

import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Parsing", package: "swift-parsing"),
]

let package = Package(
  name: "AoCCommon",
  platforms: [.macOS(.v15)],
  products: [
    .library(
      name: "AoCCommon",
      targets: ["AoCCommon"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-parsing",
      from: "0.13.0"
    ),
  ],
  targets: [
    .target(
      name: "AoCCommon",
      dependencies: dependencies
    ),
    .testTarget(
      name: "AoCCommonTests",
      dependencies: ["AoCCommon"]
    ),
  ]
)
