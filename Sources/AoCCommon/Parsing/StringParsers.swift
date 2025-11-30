import Parsing

/// Parses a string containing newlines into an array of lines.
///
/// This parser splits the input on newline characters (`"\n"`) and returns
/// each line as a `String`. The entire input must be consumed.
public struct LinesParser: Parser {
  public var body: some Parser<Substring, [String]> {
    Many {
      Prefix { $0 != "\n" }.map(String.init)
    } separator: {
      "\n"
    } terminator: {
      End()
    }
  }
}

/// Parses a single line of characters up to, but not including, a newline.
public struct CharacterLineParser: Parser {
  public var body: some Parser<Substring, [Character]> {
    Parse(Array.init) {
      Prefix { $0 != "\n" }
    }
  }
}

/// Parses a string containing multiple lines into an array of character arrays (`[[Character]]`).
///
/// Each inner array corresponds to one line and contains the characters in
/// that line.
public struct CharacterLinesParser: Parser {
  public var body: some Parser<Substring, [[Character]]> {
    Many {
      CharacterLineParser()
    } separator: {
      "\n"
    } terminator: {
      End()
    }
  }
}
