import Parsing

/// Parse a String with newlines  into an array of Strings separated on those newlines
struct LinesParser: Parser {
  var body: some Parser<Substring, [String]> {
    Many {
      Prefix { $0 != "\n" }.map(String.init)
    } separator: {
      "\n"
    } terminator: {
      End()
    }
  }
}

extension String {
  /// The String as an array af Strings, separated by newlines
  /// Errors cause a fatalError with the reason.
  public func lines() throws -> [String] {
    do {
      return try LinesParser().parse(self)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }
}
