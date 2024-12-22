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

  @Test("Manhattan Distance")
  func manhattanDistance() {
    let from = Cell(1, 2)
    let to = Cell(3, 4)
    #expect(from.manhattanDistance(to) == 4)
    #expect(from.manhattanDistance(from) == 0)
  }

}

