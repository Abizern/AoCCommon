import AoCCommon
import Testing

@Suite("Test String Parsing extensions")
struct StringParsingTests {
  @Test("String.lines()")
  func lines() throws {
    let str = "abcd123--\nwxyz"
    try #expect(str.lines() == ["abcd123--", "wxyz"])
  }

  @Test("String.characterLines()")
  func characterLines() throws {
    let str =
      """
      AB
      CD
      """

    try #expect(str.characterLines() == [[Character("A"), Character("B")], [Character("C"), Character("D")]])
  }

  @Test("String.numberRanges()")
  func numberRanges() throws {
    let str = "10-12,13-15"
    let parsed = try str.numberRanges()
    #expect(parsed.count == 2)
    #expect(parsed[0] == (10, 12))
    #expect(parsed[1] == (13, 15))
  }
}
