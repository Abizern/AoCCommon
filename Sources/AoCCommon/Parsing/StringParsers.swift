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

struct CharacterLineParser: Parser {
  var body: some Parser<Substring, [Character]> {
    Parse(Array.init) {
      Prefix { $0 != "\n" }
    }
  }
}

struct CharacterLinesParser: Parser {
  var body: some Parser<Substring, [[Character]]> {
    Many {
      CharacterLineParser()
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

extension String {
  /// The String as an array af Characters, separated by newlines
  ///
  /// Useful where the input is a character grid.
  /// Errors cause a fatalError with the reason.
  public func characterLines() -> [[Character]] {
    do {
      return try CharacterLinesParser().parse(self)
    } catch {
      fatalError("Unable to parse data \(error)")
    }
  }
}
