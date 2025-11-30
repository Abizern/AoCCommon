import AoCCommon
import Testing

@Suite("Grid initialiser")
struct GridInitialiserTests {
  @Test("Can initialise a grid with an array of arrays")
  func initialiser() {
    let rows = [[1, 2], [3, 4]]
    let grid = Grid(rows: rows)
    #expect(grid.width == 2)
    #expect(grid.height == 2)
  }
}

@Suite("Grid accessors")
struct GridAccessorsTests {
  let grid = Grid(rows: [[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  @Test("Subscripts")
  func subscripts() {
    let grid = Grid(rows: [[1, 2], [3, 4]])
    #expect(grid[0] == [1, 2])
    #expect(grid[1] == [3, 4])
    #expect(grid[1, 1] == 4)
    #expect(grid[Cell(0, 0)] == 1)
    #expect(grid[-1] == nil)
    #expect(grid[2] == nil)
    #expect(grid[0, 2] == nil)
    #expect(grid[Cell(2, 2)] == nil)
  }

  @Test("Positional validations")
  func positionalValidations() {
    let grid = Grid(rows: [[1, 2], [3, 4]])
    #expect(grid.isValidRow(0))
    #expect(grid.isValidRow(1))
    #expect(grid.isValidRow(2) == false)
    #expect(grid.isValidColumn(0))
    #expect(grid.isValidColumn(1))
    #expect(grid.isValidColumn(2) == false)
    #expect(grid.isValid(0, 0))
    #expect(grid.isValid(1, 1))
    #expect(grid.isValid(2, 0) == false)
    #expect(grid.isValid(0, 2) == false)
  }

  @Test("Positional validations using cells")
  func positionalValidationsUsingCells() {
    let grid = Grid(rows: [[1, 2], [3, 4]])
    let validPositions = [(0, 0), (1, 1)].map(Cell.init)
    let invalidPositions = [(2, 0), (0, 2)].map(Cell.init)
    #expect(validPositions.allSatisfy(grid.isValid))
    #expect(invalidPositions.allSatisfy { !grid.isValid($0) })
  }

  @Test("Element accessors")
  func elementAccessors() {
    let grid = Grid(rows: [[1, 2], [3, 4]])
    #expect(grid.element(Cell(0, 0)) == 1)
    #expect(grid.element(Cell(1, 1)) == 4)
    #expect(grid.element(Cell(2, 0)) == nil)
    #expect(grid.element(Cell(0, 2)) == nil)
  }

  @Test("Neigbours of a Cell")
  func neigboursOfACell() {
    let cell = Cell(1, 1)
    let allNeighbours = cell.neighbours()
    let orthogonalNeighbours = cell.orthogonalNeighbours()
    let diagonalNeighgbours = cell.diagonalNeighbours()
    #expect(grid.neighbours(cell) == allNeighbours)
    #expect(grid.orthogonalNeighbours(cell) == orthogonalNeighbours)
    #expect(grid.diagonalNeighbours(cell) == diagonalNeighgbours)
  }

  @Test("Find element")
  func findElement() {
    #expect(grid.firstCell(for: 2) == Cell(0, 1))
    #expect(grid.firstCell(for: 10) == nil)
  }
}

@Suite("Lazy sequences")
struct GridLazyAccessorTests {
  let grid = Grid(rows: [[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  @Test("Lazy rows")
  func lazyRows() {
    for (r, row) in grid.rows.enumerated() {
      #expect(row == grid[r])
    }
  }

  @Test("Lazy columns")
  func lazyColumns() {
    var newArray = [[Int]]()
    for column in grid.cols {
      newArray.append(column)
    }

    #expect(newArray == [[1, 4, 7], [2, 5, 8], [3, 6, 9]])
  }
}

@Suite("Grid filter")
struct GridFilterTests {
  let grid = Grid(rows: [[1, 2, 3], [4, 5, 6], [7, 8, 9]])

  @Test("Filter even numbers returns correct cells")
  func filterEvens() {
    let cells = grid.filter { $0 % 2 == 0 }
    let expected: Set<Cell> = [Cell(0, 1), Cell(1, 0), Cell(1, 2), Cell(2, 1)]
    #expect(cells == expected)
    #expect(cells.count == expected.count)
  }

  @Test("Filter with no matches returns empty")
  func filterNoMatches() {
    let cells = grid.filter { _ in false }
    #expect(cells.isEmpty)
  }
}
