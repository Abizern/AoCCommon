import Foundation

/// A simple 2D grid of values.
///
/// The grid is backed by a rectangular 2D array (`[[Element]]`) where all rows
/// have the same length. Indexing follows the conventional row/column order:
/// `row` (y) first, then `col` (x).
///
/// - `width`  is the number of columns in each row.
/// - `height` is the number of rows in the grid.
///
/// Elements must conform to `Comparable`, since this is typically required
/// at the call site.
public struct Grid<Element: Comparable>: Sendable where Element: Sendable {
  /// The underlying storage for the grid.
  ///
  /// Each inner array represents a row. All rows are guaranteed to have the
  /// same length, enforced by the initializer.
  @usableFromInline
  let storage: [[Element]]

  /// The width of the grid, i.e. the number of columns.
  public let width: Int

  /// The height of the grid, i.e. the number of rows.
  public let height: Int

  /// Creates a new grid from a 2D array of elements.
  ///
  /// - Parameter rows: A non-empty array of non-empty rows. All rows must
  ///   have the same length.
  ///
  /// - Precondition: `rows` contains at least one row.
  /// - Precondition: The first row contains at least one element.
  /// - Precondition: All rows have the same length.
  @inlinable
  public init(rows: [[Element]]) {
    guard let firstRow = rows.first else {
      preconditionFailure("A grid must have at least one row!")
    }

    let rowLength = firstRow.count

    guard rowLength > 0 else {
      preconditionFailure("A grid must have at least one column!")
    }

    for row in rows.dropFirst() {
      guard row.count == rowLength else {
        preconditionFailure("All rows in the grid must have the same length!")
      }
    }

    storage = rows
    width = rowLength
    height = rows.count
  }
}

extension Grid: Equatable {}

// Validity
public extension Grid {
  /// Returns `true` if the given row index is within the grid's bounds.
  ///
  /// - Parameter row: The row index to check.
  /// - Returns: `true` if `0 <= row < height`, otherwise `false`.
  @inlinable
  func isValidRow(_ row: Int) -> Bool {
    row >= 0 && row < height
  }

  /// Returns `true` if the given column index is within the grid's bounds.
  ///
  /// - Parameter column: The column index to check.
  /// - Returns: `true` if `0 <= column < width`, otherwise `false`.
  @inlinable
  func isValidColumn(_ column: Int) -> Bool {
    column >= 0 && column < width
  }

  /// Returns `true` if the given row and column indexes are within the grid.
  ///
  /// - Parameters:
  ///   - row: The row index.
  ///   - col: The column index.
  /// - Returns: `true` if both indexes are valid, otherwise `false`.
  @inlinable
  func isValid(_ row: Int, _ col: Int) -> Bool {
    isValidRow(row) && isValidColumn(col)
  }

  /// Returns `true` if the given cell is within the grid.
  ///
  /// - Parameter cell: The `Cell` whose coordinates should be checked.
  /// - Returns: `true` if the cell's row and column indexes are valid.
  @inlinable
  func isValid(_ cell: Cell) -> Bool {
    isValid(cell.row, cell.col)
  }
}

// Element Accessors
public extension Grid {
  /// Returns the element at the given cell, if it exists.
  ///
  /// - Parameter cell: A `Cell` with the target position.
  /// - Returns: The element if the cell is within bounds, otherwise `nil`.
  @inlinable
  func element(_ cell: Cell) -> Element? {
    guard isValid(cell) else {
      return nil
    }
    return storage[cell.row][cell.col]
  }

  @inlinable
  func row(_ row: Int) -> [Element]? {
    guard isValidRow(row) else {
      return nil
    }
    return storage[row]
  }
}

// Neighbours
public extension Grid {
  /// Returns the orthogonally adjacent neighbours of a cell that lie within the grid.
  ///
  /// The set includes any of the four directions (up, down, left, right) that fall
  /// inside the grid's bounds.
  ///
  /// - Parameter cell: The cell whose neighbours are requested.
  /// - Returns: A set of neighbouring cells within the grid.
  @inlinable
  func orthogonalNeighbours(_ cell: Cell) -> Set<Cell> {
    cell.orthogonalNeighbours().filter {
      isValid($0)
    }
  }

  /// Returns the diagonally adjacent neighbours of a cell that lie within the grid.
  ///
  /// The set includes any of the four diagonals (top-left, top-right, bottom-left,
  /// bottom-right) that fall inside the grid's bounds.
  ///
  /// - Parameter cell: The cell whose neighbours are requested.
  /// - Returns: A set of diagonal neighbours within the grid.
  @inlinable
  func diagonalNeighbours(_ cell: Cell) -> Set<Cell> {
    cell.diagonalNeighbours().filter {
      isValid($0)
    }
  }

  /// Returns all neighbours of a cell that lie within the grid.
  ///
  /// This includes both orthogonal and diagonal neighbours, filtered to only those
  /// positions that are in bounds.
  ///
  /// - Parameter cell: The cell whose neighbours are requested.
  /// - Returns: A set of all neighbouring cells within the grid.
  @inlinable
  func neighbours(_ cell: Cell) -> Set<Cell> {
    cell.neighbours().filter {
      isValid($0)
    }
  }
}

// Filtering
public extension Grid {
  /// Returns a set of `Cell`s whose values satisfy the given predicate.
  ///
  /// - Parameter predicate: A closure that takes an element and returns `true`
  ///   if the corresponding cell should be included.
  /// - Returns: A set of cells where the value at that cell satisfies the predicate.
  @inlinable
  func cells(where predicate: (Element) throws -> Bool) rethrows -> Set<Cell> {
    var accumulator: Set<Cell> = []
    for row in 0 ..< height {
      for col in 0 ..< width {
        let value = storage[row][col]
        if try predicate(value) {
          accumulator.insert(Cell(row, col))
        }
      }
    }
    return accumulator
  }
}

// Lazy Sequences
public extension Grid {
  /// A lazy sequence of all rows in the grid.
  ///
  /// Each element of the sequence is a full row `[Element]`.
  var rows: LazyMapSequence<Range<Int>, [Element]> {
    (0 ..< height).lazy.map { row in
      self.storage[row]
    }
  }

  /// A lazy sequence of all columns in the grid.
  ///
  /// Each element of the sequence is a full column `[Element]`.
  var cols: LazyMapSequence<Range<Int>, [Element]> {
    (0 ..< width).lazy.map { col in
      (0 ..< height).map { row in
        storage[row][col]
      }
    }
  }
}

// Subscripts
public extension Grid {
  /// Returns the element at a given row and column, if it exists.
  ///
  /// - Parameters:
  ///   - row: The row index.
  ///   - col: The column index.
  /// - Returns: The element at `(row, col)` if the indexes are valid, otherwise `nil`.
  @inlinable
  subscript(_ row: Int, _ col: Int) -> Element? {
    guard isValid(row, col) else {
      return nil
    }
    return storage[row][col]
  }

  /// Returns the element at a given cell, if it exists.
  ///
  /// - Parameter cell: The cell whose value is requested.
  /// - Returns: The element at `cell` if it is within bounds, otherwise `nil`.
  @inlinable
  subscript(_ cell: Cell) -> Element? {
    guard isValid(cell.row, cell.col) else {
      return nil
    }
    return storage[cell.row][cell.col]
  }
}

public extension Grid {
  /// Returns the first cell whose value is equal to the given element.
  ///
  /// The grid is scanned row by row from top-left to bottom-right. The first
  /// matching cell is returned, or `nil` if the value is not present.
  ///
  /// - Parameter element: The value to search for.
  /// - Returns: The first `Cell` containing `element`, or `nil` if not found.
  @inlinable
  func firstCell(for element: Element) -> Cell? {
    for (r, row) in rows.enumerated() {
      for (c, value) in row.enumerated() {
        if value == element {
          return Cell(r, c)
        }
      }
    }
    return nil
  }
}

extension Grid: CustomStringConvertible where Element: CustomStringConvertible {
  public var description: String {
    rows.map {
      $0.map(\.description)
        .joined(separator: "")
    }
    .joined(separator: "\n")
  }
}

// Mapping
public extension Grid {
  /// Returns a new `Grid` by applying `transform` to every element,
  /// preserving the original grid's shape.
  ///
  /// - Parameter transform: A closure that transforms each element.
  /// - Returns: A `Grid<NewElement>` with the same dimensions.
  @inlinable
  func mapGrid<NewElement>(
    _ transform: (Element) throws -> NewElement,
  ) rethrows -> Grid<NewElement>
    where NewElement: Comparable & Sendable
  {
    var newRows: [[NewElement]] = []
    newRows.reserveCapacity(height)

    for r in 0 ..< height {
      var newRow: [NewElement] = []
      newRow.reserveCapacity(width)

      for c in 0 ..< width {
        try newRow.append(transform(storage[r][c]))
      }

      newRows.append(newRow)
    }

    return Grid<NewElement>(rows: newRows)
  }
}

/// Iteration
public extension Grid {
  /// Returns a lazy sequence of grids obtained by repeatedly applying
  /// a *shape-preserving* element-wise transform to this grid.
  ///
  /// The first element of the sequence is `self`. Each subsequent grid is
  /// produced by applying `mapGrid(transform)` to the previous one.
  ///
  /// This sequence is potentially unbounded; combine it with `prefix(_:)`
  /// or `prefix(while:)` to limit it.
  @inlinable
  func iterateMap(
    _ transform: @escaping (Element) -> Element,
  ) -> UnfoldFirstSequence<Grid> {
    sequence(first: self) { current in
      current.mapGrid(transform)
    }
  }
}
