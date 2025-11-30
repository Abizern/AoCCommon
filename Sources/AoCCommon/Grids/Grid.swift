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

public extension Grid {
  /// Returns `true` if the given row index is within the grid's bounds.
  ///
  /// - Parameter row: The row index to check.
  /// - Returns: `true` if `0 <= row < height`, otherwise `false`.
  func isValidRow(_ row: Int) -> Bool {
    row >= 0 && row < height
  }

  /// Returns `true` if the given column index is within the grid's bounds.
  ///
  /// - Parameter column: The column index to check.
  /// - Returns: `true` if `0 <= column < width`, otherwise `false`.
  func isValidColumn(_ column: Int) -> Bool {
    column >= 0 && column < width
  }

  /// Returns `true` if the given row and column indexes are within the grid.
  ///
  /// - Parameters:
  ///   - row: The row index.
  ///   - col: The column index.
  /// - Returns: `true` if both indexes are valid, otherwise `false`.
  func isValid(_ row: Int, _ col: Int) -> Bool {
    isValidRow(row) && isValidColumn(col)
  }

  /// Returns `true` if the given cell is within the grid.
  ///
  /// - Parameter cell: The `Cell` whose coordinates should be checked.
  /// - Returns: `true` if the cell's row and column indexes are valid.
  func isValid(_ cell: Cell) -> Bool {
    isValid(cell.row, cell.col)
  }

  /// Returns the element at the given cell, if it exists.
  ///
  /// - Parameter cell: A `Cell` with the target position.
  /// - Returns: The element if the cell is within bounds, otherwise `nil`.
  func element(_ cell: Cell) -> Element? {
    guard isValid(cell) else {
      return nil
    }
    return storage[cell.row][cell.col]
  }

  /// Returns the orthogonally adjacent neighbours of a cell that lie within the grid.
  ///
  /// The set includes any of the four directions (up, down, left, right) that fall
  /// inside the grid's bounds.
  ///
  /// - Parameter cell: The cell whose neighbours are requested.
  /// - Returns: A set of neighbouring cells within the grid.
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
  func neighbours(_ cell: Cell) -> Set<Cell> {
    cell.neighbours().filter {
      isValid($0)
    }
  }
}

// Lazy Sequences
public extension Grid {
  /// A lazy sequence of all rows in the grid.
  ///
  /// Each element of the sequence is a full row `[Element]`.
  var rows: LazyMapSequence<Range<Int>, [Element]> {
    (0 ..< height).lazy.map { row in
      self[row]!
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

public extension Grid {
  /// Returns a set of `Cell` whose values satisfy the given predicate.
  ///
  /// - Parameter predicate: A closure that takes an element and returns `true`
  ///   if the corresponding cell should be included.
  /// - Returns: A set of cells where the value at that cell satisfies the predicate.
  func filter(_ predicate: (Element) throws -> Bool) rethrows -> Set<Cell> {
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

public extension Grid {
  /// Returns the row at the given index, if it exists.
  ///
  /// - Parameter row: The row index.
  /// - Returns: The row as `[Element]` if the index is valid, otherwise `nil`.
  subscript(_ row: Int) -> [Element]? {
    guard isValidRow(row) else {
      return nil
    }
    return storage[row]
  }

  /// Returns the element at a given row and column, if it exists.
  ///
  /// - Parameters:
  ///   - row: The row index.
  ///   - col: The column index.
  /// - Returns: The element at `(row, col)` if the indexes are valid, otherwise `nil`.
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
