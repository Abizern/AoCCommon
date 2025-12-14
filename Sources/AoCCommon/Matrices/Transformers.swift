import Foundation

/// Transpose a matrix by row major order
///
/// For example, given this matrix
/// ```swift
/// [[1, 2, 3],
///  [4, 5, 6],
///  [7, 8, 9],]
/// ```
/// the traspose is
/// ```swift
/// [[1, 4, 7],
///  [2, 5, 8],
///  [3, 6, 9],]
/// ```
///
/// - Parameter lines: the rows that make up the matrix
/// - Returns: The transposed matrix
@inlinable
public func transpose<T>(_ lines: [[T]]) -> [[T]] {
  guard let first = lines.first else { return [] }
  return (0 ..< first.count).map { col in
    lines.map { $0[col] }
  }
}

/// Rotate a matrix clockwise
///
/// Fox example:
/// ```swift
/// [[1, 2, 3],
///  [4, 5, 6],
///  [7, 8, 9]]
/// ```
/// becomes:
/// ```swift
/// [[7, 4, 1],
///  [8, 5, 2],
///  [9, 6, 3]]
/// ```
/// - Parameter lines: an array of arrays, each one a row
/// - Returns: a matrix rotated to the right
@inlinable
public func rotateRight<T>(_ lines: [[T]]) -> [[T]] {
  guard let firstRow = lines.first else { return [] }
  let rowCount = lines.count
  let colCount = firstRow.count

  precondition(lines.allSatisfy { $0.count == colCount },
               "All rows must have the same length")

  var result: [[T]] = Array(
    repeating: Array(
      repeating: firstRow[0],
      count: rowCount,
    ),
    count: colCount,
  )

  for y in 0 ..< rowCount {
    for x in 0 ..< colCount {
      result[x][rowCount - 1 - y] = lines[y][x]
    }
  }

  return result
}

/// Flip a matrix vertically, along the vertical axis
///
/// Fox example:
/// ```swift
/// [[1, 2, 3],
///  [4, 5, 6],
///  [7, 8, 9]]
/// ```
/// becomes:
/// ```swift
/// [[3, 2, 1],
///  [6, 5, 4],
///  [9, 8, 7]]
/// ```
///
/// - Parameter lines: an array of arrays, each one a row
/// - Returns: The matrix flipped along the vertical axis.
@inlinable
public func flipVertically<T>(_ lines: [[T]]) -> [[T]] {
  guard let firstRow = lines.first else { return [] }
  let colCount = firstRow.count
  precondition(lines.allSatisfy { $0.count == colCount },
               "All rows must have the same length")

  return lines.map { $0.reversed() }
}
