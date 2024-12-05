import AoCCommon
import Testing

@Suite("Cell Tests")
struct CellTests {
  @Test("Initialisers")
  func testInitialisers() {
    let cell = Cell(1, 2)
    #expect(cell.row == 1)
    #expect(cell.col == 2)
  }
}
