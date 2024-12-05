import AoCCommon
import Testing

@Suite("Test String extension for parsing")
struct StringParsingTests {
  @Test("String.lines()")
  func lines() throws {
    let str = "abcd123--\nwxyz"
    try #expect(str.lines() == ["abcd123--", "wxyz"])
  }
}
