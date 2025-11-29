import Parsing

/// When the input is multiple lines, each a string, and each Character being an Value in the grid.
public struct SingleDigitGridParser: Parser {
  public init() {}

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
