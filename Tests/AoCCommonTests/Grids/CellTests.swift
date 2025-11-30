import AoCCommon
import Testing

@Suite("Cell Tests")
struct CellTests {
  @Test("Initialise with row and column")
  func initialisersRC() {
    let cell = Cell(1, 2)
    #expect(cell.row == 1)
    #expect(cell.col == 2)
  }

  @Test("Initialise with pair")
  func initialisersTuple() {
    let cell = Cell((1, 2))
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

  @Test("Description")
  func description() {
    let cell = Cell(1, 3)
    #expect(cell.description == "(1, 3)")
  }

  @Test("Orthogonal Neighbours")
  func orthogonalNeighbours() {
    let cell = Cell(1, 2)
    let neighbours = cell.orthogonalNeighbours()
    let expected: Set<Cell> = [Cell(0, 2), Cell(1, 1), Cell(1, 3), Cell(2, 2)]
    #expect(neighbours.count == 4)
    #expect(neighbours == expected)
  }

  @Test("Diagonal neighbours")
  func diagonalNeighbours() {
    let cell = Cell(1, 2)
    let neighbours = cell.diagonalNeighbours()
    let expected: Set<Cell> = [Cell(0, 1), Cell(0, 3), Cell(2, 1), Cell(2, 3)]
    #expect(neighbours.count == 4)
    #expect(neighbours == expected)
  }

  @Test("Neighbours")
  func neighbours() {
    let cell = Cell(1, 2)
    let neighbours = cell.neighbours()
    let expected: Set<Cell> = [
      Cell(0, 1), Cell(0, 2), Cell(0, 3), Cell(1, 1), Cell(1, 3), Cell(2, 1), Cell(2, 2), Cell(2, 3),
    ]
    #expect(neighbours.count == 8)
    #expect(neighbours == expected)
  }

  @Test("Specific neighbours")
  func specificNeighbours() {
    let cell = Cell(1, 2)
    let offsets: [Cell.Offset] = [.up, .bottomLeft]
    let neighbours = cell.offsets(by: offsets)
    let expected: Set<Cell> = [Cell(0, 2), Cell(2, 1)]

    #expect(neighbours.count == 2)
    #expect(neighbours == expected)
  }
}
