import Foundation

/// Representation af a cell in 2D grid
public struct Cell: Hashable, CustomStringConvertible, Sendable {
  /// The horizontal position
  public let row: Int
  /// The vertical position
  public let col: Int

  public init(_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

  public init(_ pair: (Int, Int)) {
    row = pair.0
    col = pair.1
  }

  public var description: String {
    "(\(row), \(col))"
  }
}
