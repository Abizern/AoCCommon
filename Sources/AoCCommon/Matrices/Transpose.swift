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
