import Parsing

/// A parser for a pair of numbers from a string.
///
/// The parser expects two decimal integers separated by a fixed delimiter
/// (`,` by default) and then applies an optional transform to the parsed pair.
///
/// For example, given the input `"3,7"`:
/// - with the default transform, this parses as `(3, 7)`
/// - with a custom transform, you can map it to any `V`,
///
/// The generic parameter `V` is the output type produced by the `transform`
/// closure.
public struct NumberPair<V>: Parser {
  /// The separator expected between the two numbers.
  @usableFromInline
  let separator: String

  /// The transform, if any, to apply to the parsed pair `(lhs, rhs)`.
  @usableFromInline
  let transform: ((Int, Int)) -> V

  /// Creates a parser for two integers separated by `separator`.
  ///
  /// - Parameters:
  ///   - separator: The literal string separating the two numbers. Defaults to `","`.
  ///   - transform: A closure that converts the parsed `(Int, Int)` into `V`.
  ///                By default this is the identity and `V == (Int, Int)`.
  @inlinable
  public init(
    separator: String = ",",
    transform: @escaping ((Int, Int)) -> V = { $0 },
  ) {
    self.separator = separator
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, V> {
    Parse(transform) {
      Digits()
      separator
      Digits()
    }
  }
}

/// A Parser for a range of numbers separated by "-"
///
/// For example
/// ```swift
/// "12-15" // (12, 15)
/// ```
public struct NumberRange: Parser {
  @inlinable
  public init() {}

  @inlinable
  public var body: some Parser<Substring, (Int, Int)> {
    Parse {
      NumberPair(separator: "-")
    }
  }
}

/// A Parser for a list of number ranges, separated by "\n"
///
/// for Example
/// ```swift
/// """
/// 1-2
/// 3-4 // -> [(1, 2), (3, 4)]
/// """
/// ```
public struct NumberRangeLines: Parser {
  @inlinable
  public init() {}

  @inlinable
  public var body: some Parser<Substring, [(Int, Int)]> {
    Parse {
      Many {
        NumberRange()
      } separator: {
        "\n"
      }
    }
  }
}

/// A parser for a single line of ranges separated by a comma
///
/// for example
/// ```swift
/// "1-2,3-4"
///
/// // [(1,2), (3,4)]
/// ```
public struct NumberRanges: Parser {
  @inlinable
  public init() {}

  @inlinable
  public var body: some Parser<Substring, [(Int, Int)]> {
    Many {
      NumberRange()
    } separator: {
      ","
    } terminator: {
      End()
    }
  }
}

/// A parser for multiple lines of number pairs.
///
/// This parser repeatedly applies `NumberPair` to each line in the input,
/// expecting a newline (`"\n"`) between lines.
///
/// For example, with the default configuration, it will parse:
///
/// ```text
/// 1,2
/// 3,4
/// 5,6
/// ```
///
/// into an array of `V` values, one for each line.
public struct NumberPairs<V>: Parser {
  /// The separator expected between the numbers on each line.
  @usableFromInline
  let separator: String

  /// The transform, if any, to apply to each parsed pair `(lhs, rhs)`.
  @usableFromInline
  let transform: ((Int, Int)) -> V

  /// Creates a parser for lines of number pairs separated by newlines.
  ///
  /// - Parameters:
  ///   - separator: The literal string separating the two numbers on a line.
  ///                Defaults to `","`.
  ///   - transform: A closure that converts each parsed `(Int, Int)` into `V`.
  ///                By default this is the identity and `V == (Int, Int)`.
  @inlinable
  public init(
    separator: String = ",",
    transform: @escaping ((Int, Int)) -> V = { $0 },
  ) {
    self.separator = separator
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, [V]> {
    Many {
      NumberPair(separator: separator, transform: transform)
    } separator: {
      "\n"
    }
  }
}

/// A parser for a single line of numbers separated by a delimiter.
///
/// The line is interpreted as a list of decimal integers separated by a
/// configurable string (`,` by default). Each parsed `Int` is then mapped
/// into the generic output type `V` via the `transform` closure.
///
/// For example, with the default configuration, the input:
///
/// ```text
/// 1,2,3,4
/// ```
///
/// is parsed as `[1, 2, 3, 4]` (or `[V]` after transformation).
public struct NumberLine<V>: Parser {
  /// The separator expected between the numbers on this line.
  @usableFromInline
  let separator: String

  /// The transform applied to each parsed integer.
  @usableFromInline
  let transform: (Int) -> V

  /// Creates a parser for a single line of separated integers.
  ///
  /// - Parameters:
  ///   - separator: The literal string separating the numbers on the line.
  ///                Defaults to `","`.
  ///   - transform: A closure that converts each parsed `Int` into `V`.
  ///                By default this is the identity and `V == Int`.
  @inlinable
  public init(
    separator: String = ",",
    transform: @escaping (Int) -> V = { $0 },
  ) {
    self.separator = separator
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, [V]> {
    Parse {
      Many {
        Int.parser().map(transform)
      } separator: {
        separator
      }
    }
  }
}

/// A parser for multiple lines of separated numbers.
///
/// This repeatedly applies `NumberLine` and expects newline characters
/// (`"\n"`) between lines, producing a 2D array of `V` values.
///
/// For example, with the default configuration, the input:
///
/// ```text
/// 1,2,3
/// 4,5,6
/// ```
///
/// is parsed as:
///
/// ```swift
/// [[1, 2, 3], [4, 5, 6]]  // or [[V]] after transformation
/// ```
///
/// This is a convenient building block for grid-like numeric inputs where
/// each row is comma- (or otherwise) separated.
public struct NumberLines<V>: Parser {
  /// The separator expected between numbers on each line.
  @usableFromInline
  let separator: String

  /// The transform applied to each parsed integer.
  @usableFromInline
  let transform: (Int) -> V

  /// Creates a parser for multiple lines of separated integers.
  ///
  /// - Parameters:
  ///   - separator: The literal string separating numbers on each line.
  ///                Defaults to `","`.
  ///   - transform: A closure that converts each parsed `Int` into `V`.
  ///                By default this is the identity.
  @inlinable
  public init(
    separator: String = ",",
    transform: @escaping (Int) -> V = { $0 },
  ) {
    self.separator = separator
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, [[V]]> {
    Many {
      NumberLine(separator: separator, transform: transform)
    } separator: {
      "\n"
    }
  }
}

/// A parser for a line of single digits with no separators.
///
/// This expects a contiguous sequence of decimal digits (`0`–`9`) on a single
/// line, with no spaces or delimiters. Each character is parsed as a single
/// digit `Int` and then mapped to `V` using the `transform` closure.
///
/// For example, the input:
///
/// ```text
/// 12345
/// ```
///
/// is parsed as `[1, 2, 3, 4, 5]` (or `[V]` after transformation).
public struct SingleDigitLineParser<V>: Parser {
  /// The transform applied to each parsed digit.
  @usableFromInline
  let transform: (Int) -> V

  /// Creates a parser for a single line of contiguous digits.
  ///
  /// - Parameter transform: A closure that converts each parsed digit `Int`
  ///                        into `V`. By default this is the identity and
  ///                        `V == Int`.
  @inlinable
  public init(transform: @escaping (Int) -> V = { $0 }) {
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, [V]> {
    Many {
      Digits(1).map(transform)
    }
  }
}

/// A parser for a grid of single digits in a block without spaces.
///
/// This parser treats the input as multiple lines of contiguous digits,
/// separated by newlines, and returns a 2D array of transformed values `[[V]]`.
///
/// For example, the input:
///
/// ```text
/// 123
/// 456
/// 789
/// ```
///
/// is parsed as:
///
/// ```swift
/// [[1, 2, 3],
///  [4, 5, 6],
///  [7, 8, 9]]  // or [[V]] after transformation
/// ```
public struct SingleDigitLinesParser<V>: Parser {
  /// The transform applied to each parsed digit.
  @usableFromInline
  let transform: (Int) -> V

  /// Creates a parser for multiple lines of contiguous digits.
  ///
  /// - Parameter transform: A closure that converts each parsed digit `Int`
  ///                        into `V`. By default this is the identity and
  ///                        `V == Int`.
  @inlinable
  public init(transform: @escaping (Int) -> V = { $0 }) {
    self.transform = transform
  }

  @inlinable
  public var body: some Parser<Substring, [[V]]> {
    Many {
      SingleDigitLineParser(transform: transform)
    } separator: {
      "\n"
    }
  }
}
