# AoCCommon

Common utility code for Advent of Code solutions in Swift.

Mostly this is just Parsing with some grid and number theory helpers

## Installation
To use the `AoCCommon` library in a SwiftPM project, add the following line to the dependencies in your `Package.swift` file:

```swift
.package(url: "https://github.com/Abizern/AoCCommon", "0.1.0" ..< "0.2.0"),
```

This will define a dependency up to the next minor version.

Include `AoCCommon` as a dependency for your target:

```swift
.target(name: "<target>", dependencies: [
    .product(name: "AoCCommon", package: "AoCCommon"),
]),
```
