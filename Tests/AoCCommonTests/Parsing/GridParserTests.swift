import AoCCommon
import Testing

@Suite("Grid Parser Tests")
struct GridParserTests {
  @Test("SingleDigitGridParser")
  func singleDigitGridParser() throws {
    let input =
      """
      123
      456
      """
    let grid = try SingleDigitGridParser().parse(input)
    #expect(grid.width == 3)
    #expect(grid.height == 2)
    #expect(grid.row(0) == [1, 2, 3])
    #expect(grid.row(1) == [4, 5, 6])
  }
}
