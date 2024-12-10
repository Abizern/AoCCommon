import AoCCommon
import Testing

@Suite("Test NumberPair")
struct NumberPairTests {
  @Test("Default separates on commas")
  func defaultSeparator() throws {
    let str = "1,2"
    try #expect(NumberPair().parse(str) == (1, 2))
  }

  @Test("Use a space separator")
  func spaceSeparator() throws {
    let str = "1 2"
    let parser = NumberPair(separator: " ")
    try #expect(parser.parse(str) == (1, 2))
  }

  @Test("Transform the tuples")
  func transform() throws {
    let str = "1 2"
    let parser = NumberPair(separator: " ") { a, b -> Int in
      a + b
    }
    try #expect(parser.parse(str) == 3)
  }

  @Test("Multiple Lines")
  func multipleLines() throws {
    let str =
      """
      1,2
      3,4
      """
    let parser = Many {
      NumberPair()
    } separator: {
      "\n"
    } terminator: {
      End()
    }

    let parsed = try parser.parse(str)
    #expect(parsed[0] == (1, 2))
    #expect(parsed[1] == (3, 4))
  }
}

@Suite("Test NumberPairs")
struct NumberPairsTests {
  @Test("Default separates on commas")
  func defaultSeparator() throws {
    let str =
      """
      1,2
      3,4
      """
    let parsed = try NumberPairs().parse(str)
    #expect(parsed[0] == (1, 2))
    #expect(parsed[1] == (3, 4))
  }
}

@Suite("Test NumberLine")
struct NumberLineTests {
  @Test("Default separats on commas")
  func defaultSeparator() throws {
    let str = "1,2,3,4"
    let parsed = try NumberLine().parse(str)
    #expect(parsed == [1, 2, 3, 4])
  }

  @Test("Separate on spaces")
  func spacesSeparator() throws {
    let str = "1 2 3 4"
    let parsed = try NumberLine(separator: " ").parse(str)
    #expect(parsed == [1, 2, 3, 4])
  }

  @Test("Transformer")
  func transformer() throws {
    let str = "1 2 3 4"
    let parsed = try NumberLine(separator: " ") {
      $0 * 2
    }.parse(str)
    #expect(parsed == [2, 4, 6, 8])
  }
}

@Suite("Test NumberLines")
struct NumberrLinesTests {
  @Test("Default separates on commas")
  func defaultSeparator() throws {
    let str =
      """
      1,2,3
      4,5,6
      """
    let parsed = try NumberLines().parse(str)
    #expect(parsed[0] == [1, 2, 3])
    #expect(parsed[1] == [4, 5, 6])
  }
}

@Suite("SingleDigitLineParser Test")
struct SingleDightLineParserTests {
  @Test("Parse a single line")
  func parseSingleLine() throws {
    let str = "123"
    let parsed = try SingleDigitLineParser().parse(str)
    #expect(parsed == [1, 2, 3])
  }

  @Test("Transform")
  func transform() throws {
    let str = "123"
    let parser = SingleDigitLineParser() { $0 * 2 }
    #expect(try parser.parse(str) == [2, 4, 6])
  }
}

@Suite("SingleDigitLinesParser Test")
struct SingleDightLinesParserTests {
  @Test("Parse a single line")
  func parseSingleLine() throws {
    let str =
      """
      123
      456
      789
      """
    let parsed = try SingleDigitLinesParser().parse(str)
    #expect(parsed[0] == [1, 2, 3])
    #expect(parsed[1] == [4, 5, 6])
    #expect(parsed[2] == [7, 8, 9])
  }

  @Test("Transform")
  func transform() throws {
    let str =
      """
      123
      456
      """
    let parser = SingleDigitLinesParser() { $0 * 2 }
    let parsed = try parser.parse(str)
    #expect(parsed[0] == [2, 4, 6])
    #expect(parsed[1] == [8, 10, 12])
  }
}
