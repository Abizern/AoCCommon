import Parsing

/// A Parse for a pair of numbers  from a string
/// The default separator is a comma
/// The default transformer does nothing.
public struct NumbersPair<V>: Parser {
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
