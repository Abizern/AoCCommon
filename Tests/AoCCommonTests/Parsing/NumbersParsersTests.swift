import AoCCommon
import Testing

@Suite("Test NumbersPair")
struct NumbersPairsTests {
  @Test("Default separates on commas")
  func defaultSeparator() throws {
    let str = "1,2"
    try #expect(NumbersPair().parse(str) == (1, 2))
  }

  @Test("Use a space separator")
  func spaceSeparator() throws {
    let str = "1 2"
    let parser = NumbersPair(separator: " ")
    try #expect(parser.parse(str) == (1, 2))
  }

  @Test("Transform the out")
  func transform() throws {
    let str = "1 2"
    let parser = NumbersPair(separator: " ") { a, b -> Int in
      a + b
    }
    try #expect(parser.parse(str) == 3)
  }
}
