// swift-tools-version: 6.2

import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Parsing", package: "swift-parsing"),
  .product(name: "Collections", package: "swift-collections"),
]

let package = Package(
  name: "AoCCommon",
  platforms: [.macOS(.v15), .iOS(.v26), .tvOS(.v26), .watchOS(.v26)],
  products: [
    .library(
      name: "AoCCommon",
      targets: ["AoCCommon"],
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-parsing", "0.14.1" ..< "0.15.0",
    ),
    .package(
      url: "https://github.com/apple/swift-collections.git", "1.3.0" ..< "1.4.0",
    ),
    .package(
      url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0",
    ),
  ],
  targets: [
    .target(
      name: "AoCCommon",
      dependencies: dependencies,
    ),
    .testTarget(
      name: "AoCCommonTests",
      dependencies: ["AoCCommon"],
    ),
  ],
)
