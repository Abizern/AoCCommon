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

    let lines = str.characterLines()
    #expect(lines == [[Character("A"), Character("B")], [Character("C"), Character("D")]])
  }
}
