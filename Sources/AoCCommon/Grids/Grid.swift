import Foundation

// TODO: Turn this into a Monad

/// A simple 2D Grid structure of Elements
///
/// Refences are in the order of Row then Column (so y, then x)
/// Elements are expected to be Comparable for equality and comparison checks at the call site.
public struct Grid<Element: Comparable>: Sendable where Element: Sendable {
  let storage: [[Element]]

  /// The width of the grid, i.e. the number of columns
  public let width: Int

  /// The height of the grid i.e. the number of rows
  public let height: Int

  public init(rows: [[Element]]) {
    storage = rows
    let rowLength = rows[0].count
    guard rowLength > 0
    else {
      preconditionFailure("A grid cannot be empty!")
    }

    var numberOfRows = 1
    for row in rows.dropFirst() {
      guard row.count == rowLength else {
        preconditionFailure("All rows must have the same length!")
      }
      numberOfRows += 1
    }

    width = rowLength
    height = numberOfRows
  }
}

extension Grid {
  /// A check if the row exists in the grid
  public func isValidRow(_ row: Int) -> Bool {
    row >= 0 && row < height
  }

  /// A check if the column exists in the grid
  public func isValidColumn(_ column: Int) -> Bool {
    column >= 0 && column < width
  }

  /// A check if the row and column indexes are in the grid
  /// - Parameters:
  ///   - row: the row index
  ///   - col: the column index
  /// - Returns: true if the row and column are valid indexes
  public func isValid(_ row: Int, _ col: Int) -> Bool {
    isValidRow(row) && isValidColumn(col)
  }

  public func isValid(_ cell: Cell) -> Bool {
    isValid(cell.row, cell.col)
  }

  /// The element at the given position (row, column) if it exists
  /// - Parameter cell: a `Cell` with the target position
  /// - Returns: the element if it exists, or else `nil`
  public func element(_ cell: Cell) -> Element? {
    guard isValid(cell) else {
      return nil
    }
    return storage[cell.row][cell.col]
  }

  /// Returns an array of the neighbours of the given cell
  /// - Parameters:
  ///   - cell: The target
  ///   - includeDiagonals: should diagonally adjacent cells be included, defaults to true
  /// - Returns: An array of the cells neigbouring target
  public func neighbours(_ cell: Cell, includeDiagonals: Bool = true) -> [Cell] {
    var neighbours: [Cell] = []
    let offsets = includeDiagonals
      ? [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
      : [(0, -1), (0, 1), (-1, 0), (1, 0)]
    for (rOffset, cOffset) in offsets {
      let newRow = cell.row + rOffset
      let newCol = cell.col + cOffset
      if isValid(newRow, newCol) {
        neighbours.append(Cell(newRow, newCol))
      }
    }

    return neighbours
  }

  /// Returns a set of the neighbours of the given cell
  /// - Parameters:
  ///   - cell: The target
  ///   - includeDiagonals: should diagonally adjacent
  /// - Returns: A set of the cells surrounding the target.
  public func neighboursSet(_ cell: Cell, includeDiagonals: Bool = true) -> Set<Cell> {
    Set(neighbours(cell, includeDiagonals: includeDiagonals))
  }
}

// Lazy Sequences
extension Grid {
  /// The rows as a sequence
  public var rows: LazyMapSequence<Range<Int>, [Element]> {
    (0 ..< height).lazy.map { row in
      self[row]!
    }
  }

  /// The columns as a lazy sequence
  public var cols: LazyMapSequence<Range<Int>, [Element]> {
    (0 ..< width).lazy.map { col in
      (0 ..< height).compactMap { row in
        self[row, col]
      }
    }
  }
}

extension Grid {
  /// Return a set of Cells, where the value at that cell satisfies the predicate
  public func filter(_ predicate: (Element) throws -> Bool) rethrows -> Set<Cell> {
    var accumulator: Set<Cell> = []
    for row in 0 ..< height {
      for col in 0 ..< width {
        if let value = self[row, col], try predicate(value) {
          accumulator.insert(Cell(row, col))
        }
      }
    }
    return accumulator
  }
}

extension Grid {
  /// The row at the given index if it exists or else `nil`
  public subscript(_ row: Int) -> [Element]? {
    guard isValidRow(row) else {
      return nil
    }
    return storage[row]
  }

  /// The Element at the given index if it exists or else `nil`
  public subscript(_ row: Int, _ col: Int) -> Element? {
    guard isValid(row, col) else {
      return nil
    }
    return storage[row][col]
  }
}

extension Grid {
  /// Returns the first Cell which matches the element
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
