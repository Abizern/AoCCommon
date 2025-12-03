import Foundation

/// A lightweight value type that represents a single cell in a 2D grid.
///
/// A `Cell` stores its location using integer grid coordinates:
/// - `row`: The row index (0-based), increasing as you move downward.
/// - `col`: The column index (0-based), increasing as you move to the right.
///
/// The type conforms to:
/// - `Hashable` for use as dictionary keys and set members
/// - `CustomStringConvertible` for readable debugging output
/// - `Sendable` for safe use across concurrency domains
///
/// Typical uses include pathfinding (e.g., Manhattan distance), board games,
/// and matrix addressing. In Advent of Code puzzles, `Cell` often represents
/// a coordinate in a 2D map or heightmap.
public struct Cell: Hashable, CustomStringConvertible, Sendable {
  /// The row index (0-based). Increases as you move downward.
  public let row: Int

  /// The column index (0-based). Increases as you move right.
  public let col: Int

  /// Creates a cell at the given grid coordinates.
  ///
  ////// Example:
  /// ```swift
  /// let origin = Cell(0, 0)   // top-left
  /// let neighbor = Cell(0, 1) // same row, one column to the right
  /// ```
  ///
  /// - Parameters:
  ///   - row: The row index (0-based), increasing downward.
  ///   - col: The column index (0-based), increasing to the right.
  @inlinable
  public init(_ row: Int, _ col: Int) {
    self.row = row
    self.col = col
  }

  /// Creates a cell from a `(row, col)` tuple.
  ///
  /// - Parameter pair: A tuple where `pair.0` is the row and `pair.1` is the column.
  @inlinable
  public init(_ pair: (Int, Int)) {
    row = pair.0
    col = pair.1
  }

  /// The canonical origin cell at `(0, 0)` (top-left in a row/column grid).
  ///
  /// Useful as a starting point for grid-based algorithms, bounds checks, and
  /// default values.
  public static let origin = Cell(0, 0)

  /// A human-readable representation in the form `"(row, col)"`.
  public var description: String {
    "(\(row), \(col))"
  }
}

public extension Cell {
  /// Returns a new cell by applying the given offset to this cell.
  ///
  /// This does not perform any bounds checking; it simply adds the offset's
  /// delta to `row` and `col`.
  ///
  /// - Parameter offset: The directional offset to apply.
  /// - Returns: A new `Cell` translated by the given offset.
  @inlinable
  func offset(by offset: Offset) -> Cell {
    switch offset {
    case .up: Cell(row - 1, col)
    case .down: Cell(row + 1, col)
    case .left: Cell(row, col - 1)
    case .right: Cell(row, col + 1)
    case .topLeft: Cell(row - 1, col - 1)
    case .topRight: Cell(row - 1, col + 1)
    case .bottomLeft: Cell(row + 1, col - 1)
    case .bottomRight: Cell(row + 1, col + 1)
    }
  }

  /// Returns a set of cells obtained by applying multiple offsets.
  ///
  /// This is a convenience for applying a group of offsets around a cell,
  /// such as orthogonal or diagonal neighbours.
  ///
  /// - Parameter offsets: The offsets to apply to `self`.
  /// - Returns: A `Set` containing the distinct cells reached by the offsets.
  @inlinable
  func offsets(by offsets: [Offset]) -> Set<Cell> {
    Set(offsets.map { self.offset(by: $0) })
  }

  /// Returns the four orthogonally adjacent neighbours of this cell.
  ///
  /// These are the cells one step `up`, `down`, `left`, and `right` from `self`,
  /// without any bounds checking.
  ///
  /// - Returns: A set of orthogonal neighbours of this cell.
  @inlinable
  func orthogonalNeighbours() -> Set<Cell> {
    offsets(by: Offset.orthogonal)
  }

  /// Returns the four diagonally adjacent neighbours of this cell.
  ///
  /// These are the cells one step away in each diagonal direction:
  /// `topLeft`, `topRight`, `bottomLeft`, and `bottomRight`, without any
  /// bounds checking.
  ///
  /// - Returns: A set of diagonal neighbours of this cell.
  @inlinable
  func diagonalNeighbours() -> Set<Cell> {
    offsets(by: Offset.diagonal)
  }

  /// Returns all eight neighbours of this cell (orthogonal and diagonal).
  ///
  /// This is equivalent to `orthogonalNeighbours().union(diagonalNeighbours())`,
  /// but implemented in a single pass over all possible offsets.
  ///
  /// - Returns: A set of all neighbouring cells around this cell.
  @inlinable
  func neighbours() -> Set<Cell> {
    offsets(by: Offset.allCases)
  }

  /// Returns the Manhattan distance to another cell.
  ///
  /// The Manhattan distance is the sum of the absolute differences of the
  /// coordinates: `abs(row − other.row) + abs(col − other.col)`.
  ///
  /// Example:
  /// ```swift
  /// let a = Cell(1, 2)
  /// let b = Cell(3, 5)
  /// let d = a.manhattanDistance(b) // 5
  /// ```
  ///
  /// - Parameter to: The other cell to measure against.
  /// - Returns: The Manhattan distance between `self` and `to`.
  @inlinable
  func manhattanDistance(_ to: Cell) -> Int {
    abs(row - to.row) + abs(col - to.col)
  }
}

// Offsets
public extension Cell {
  /// A directional offset in a 2D grid, relative to a cell.
  ///
  /// Offsets can be applied to a `Cell` to obtain neighbours and other
  /// translated positions. The cases cover the four orthogonal directions
  /// and the four diagonals.
  enum Offset: CaseIterable, Sendable {
    /// One row up (decreasing `row` by 1).
    case up
    /// One column to the right (increasing `col` by 1).
    case right
    /// One row down (increasing `row` by 1).
    case down
    /// One column to the left (decreasing `col` by 1).
    case left
    /// One step up and left (decreasing both `row` and `col` by 1).
    case topLeft
    /// One step up and right (decreasing `row` by 1, increasing `col` by 1).
    case topRight
    /// One step down and left (increasing `row` by 1, decreasing `col` by 1).
    case bottomLeft
    /// One step down and right (increasing both `row` and `col` by 1).
    case bottomRight

    /// The four orthogonal directions: up, down, left, and right.
    public static var orthogonal: [Offset] { [.up, .down, .left, .right] }

    /// The four diagonal directions: top-left, top-right, bottom-left, bottom-right.
    public static var diagonal: [Offset] { [.topLeft, .topRight, .bottomLeft, .bottomRight] }
  }
}
