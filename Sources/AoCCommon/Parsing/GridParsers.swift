import Parsing

/// A parser for a grid of single decimal digits into a `Grid<Int>`.
///
/// The input is treated as multiple lines of contiguous digits (`0`–`9`)
/// separated by newlines. Each digit is parsed as an `Int`, and the resulting
/// `[[Int]]` is wrapped into a `Grid<Int>`.
///
/// For example, the input:
///
/// ```text
/// 123
/// 456
/// 789
/// ```
///
/// parses as a 3×3 `Grid` with rows:
///
/// ```swift
/// [[1, 2, 3],
///  [4, 5, 6],
///  [7, 8, 9]]
/// ```
public struct SingleDigitGridParser: Parser {
  @inlinable
  public init() {}

  @inlinable
  public var body: some Parser<Substring, Grid<Int>> {
    Many {
      SingleDigitLineParser()
    } separator: {
      "\n"
    } terminator: {
      End()
    }.map { Grid(rows: $0) }
  }
}
