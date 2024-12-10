import Parsing

/// A Parse for a pair of numbers  from a string
/// The default separator is a comma
/// The default transformer does nothing.
public struct NumberPair<V>: Parser {
  /// The separator expected between the numbers
  let separator: String

  /// The transform, if any, to apply to the parsed pair.
  let transform: ((Int, Int)) -> V

  public init(
    separator: String = ",",
    transform: @escaping ((Int, Int)) -> V = { $0 }
  ) {
    self.separator = separator
    self.transform = transform
  }

  public var body: some Parser<Substring, V> {
    Parse(transform) {
      Digits()
      separator
      Digits()
    }
  }
}

public struct NumberPairs<V>: Parser {
  /// The separator expected between the numbers
  let separator: String

  /// The transform, if any, to apply to the parsed pair.
  let transform: ((Int, Int)) -> V

  public init(
    separator: String = ",",
    transform: @escaping ((Int, Int)) -> V = { $0 }
  ) {
    self.separator = separator
    self.transform = transform
  }

  public var body: some Parser<Substring, [V]> {
    Many {
      NumberPair(separator: separator, transform: transform)
    } separator: {
      "\n"
    }
  }
}

// Documentation
public struct NumberLine<V>: Parser {
  let separator: String

  let transform: (Int) -> V

  public init(
    separator: String = ",",
    transform: @escaping (Int) -> V = { $0 }
  ) {
    self.separator = separator
    self.transform = transform
  }

  public var body: some Parser<Substring, [V]> {
    Parse{
      Many {
        Int.parser().map(transform)
      } separator: {
        separator
      }
    }
  }
}

// Documentation
public struct NumberLines<V>: Parser {
  let separator: String

  let transform: ((Int)) -> V
  
  public init(
    separator: String = ",",
    transform: @escaping ((Int)) -> V = { $0 }
  ) {
    self.separator = separator
    self.transform = transform
  }

  public var body: some Parser<Substring, [[V]]> {
    Many {
      NumberLine(separator: separator, transform: transform)
    } separator: {
      "\n"
    }
  }
}
