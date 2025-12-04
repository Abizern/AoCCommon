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
  let grid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ])

  @Test("Subscripts")
  func subscripts() {
    let grid = Grid(rows: [[1, 2], [3, 4]])
    #expect(grid.row(0) == [1, 2])
    #expect(grid.row(1) == [3, 4])
    #expect(grid[1, 1] == 4)
    #expect(grid[Cell(0, 0)] == 1)
    #expect(grid.row(-1) == nil)
    #expect(grid.row(2) == nil)
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
  let grid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ])

  @Test("Lazy rows")
  func lazyRows() {
    for (r, row) in grid.rows.enumerated() {
      #expect(row == grid.row(r))
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
  let grid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ])

  @Test("Filter even numbers returns correct cells")
  func filterEvens() {
    let cells = grid.cells { $0 % 2 == 0 }
    let expected: Set<Cell> = [Cell(0, 1), Cell(1, 0), Cell(1, 2), Cell(2, 1)]
    #expect(cells == expected)
    #expect(cells.count == expected.count)
  }

  @Test("Filter with no matches returns empty")
  func filterNoMatches() {
    let cells = grid.cells { _ in false }
    #expect(cells.isEmpty)
  }
}

@Suite("Grid Description")
struct GridDescription {
  @Test("Debug string")
  func debugString() {
    let grid = Grid(rows: [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    let expectation = "123\n456\n789"
    #expect(grid.description == expectation)
  }
}

@Suite("Grid Sequence conformance")
struct GridSequenceTests {
  let grid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ])

  @Test("For-in iteration visits elements in row-major order")
  func iterationOrder() {
    var iterated: [Int] = []

    for value in grid {
      iterated.append(value)
    }

    #expect(iterated == [1, 2, 3,
                         4, 5, 6,
                         7, 8, 9])
  }

  @Test("Array initializer from Grid flattens in row-major order")
  func arrayFlattening() {
    let asArray = Array(grid)
    #expect(asArray == [1, 2, 3,
                        4, 5, 6,
                        7, 8, 9])
  }

  @Test("map on Grid as a Sequence returns transformed values")
  func mapOnGrid() {
    let doubled = grid.map { $0 * 2 }
    #expect(doubled == [2, 4, 6,
                        8, 10, 12,
                        14, 16, 18])
  }

  @Test("reduce on Grid as a Sequence folds all elements")
  func reduceOnGrid() {
    let sum = grid.reduce(0, +)
    #expect(sum == 45)
  }

  @Test("filter on Grid as a Sequence returns values, not cells")
  func filterOnGrid() {
    let evens = grid.filter { $0.isMultiple(of: 2) }.sorted()
    #expect(evens == [2, 4, 6, 8])
  }
}

@Suite("Grid RandomAccessCollection conformance")
struct GridRandomAccessCollectionTests {
  let grid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ])

  @Test("startIndex, endIndex and count are consistent")
  func indicesAndCount() {
    #expect(grid.startIndex == 0)
    #expect(grid.endIndex == 9)
    #expect(grid.count == 9)
    #expect(grid.isEmpty == false)
  }

  @Test("Subscript by flat index uses row-major layout")
  func flatIndexSubscript() {
    for idx in grid.startIndex ..< grid.endIndex {
      #expect(grid[idx] == idx + 1)
    }
  }

  @Test("index(after:) and index(before:) walk the collection correctly")
  func indexMovement() {
    let start = grid.startIndex
    let second = grid.index(after: start)
    let third = grid.index(after: second)

    #expect(start == 0)
    #expect(second == 1)
    #expect(third == 2)
    #expect(grid[start] == 1)
    #expect(grid[second] == 2)
    #expect(grid[third] == 3)

    let last = grid.index(before: grid.endIndex)
    let penultimate = grid.index(before: last)

    #expect(last == 8)
    #expect(penultimate == 7)
    #expect(grid[last] == 9)
    #expect(grid[penultimate] == 8)
  }

  @Test("index(for:) maps Cells to flat indices consistently")
  func indexForCell() {
    // Row-major: index = row * width + col
    #expect(grid.index(for: Cell(0, 0)) == 0) // 1
    #expect(grid.index(for: Cell(0, 2)) == 2) // 3
    #expect(grid.index(for: Cell(1, 0)) == 3) // 4
    #expect(grid.index(for: Cell(2, 2)) == 8) // 9

    #expect(grid[grid.index(for: Cell(0, 0))] == 1)
    #expect(grid[grid.index(for: Cell(0, 2))] == 3)
    #expect(grid[grid.index(for: Cell(1, 0))] == 4)
    #expect(grid[grid.index(for: Cell(2, 2))] == 9)
  }
}

@Suite("Grid Equatable conformance")
struct GridEquatable {
  @Test("The same grid is equatable")
  func equalGrids() {
    let grid1: Grid<Int> = Grid(rows: [
      [0, 1, 3],
      [2, 3, 4],
    ])

    let grid2: Grid<Int> = Grid(rows: [
      [0, 1, 3],
      [2, 3, 4],
    ])
    #expect(grid1 == grid2)
  }

  @Test("Differing grids are not equatable")
  func unequalGrids() {
    let grid1: Grid<Int> = Grid(rows: [
      [0, 0, 3],
      [2, 0, 4],
    ])

    let grid2: Grid<Int> = Grid(rows: [
      [0, 1, 3],
      [2, 3, 4],
    ])
    #expect(grid1 != grid2)
  }
}

@Suite("Grid mapGrid")
struct GridMapGridTests {
  let intGrid = Grid(rows: [
    [1, 2, 3],
    [4, 5, 6],
  ])

  @Test("mapGrid preserves shape and applies transform")
  func shapeAndTransform() {
    let doubled = intGrid.mapGrid { $0 * 2 }

    #expect(doubled.width == intGrid.width)
    #expect(doubled.height == intGrid.height)

    // Values transformed in row-major order
    #expect(doubled.row(0) == [2, 4, 6])
    #expect(doubled.row(1) == [8, 10, 12])
  }

  @Test("mapGrid supports changing element type")
  func changeElementType() {
    let charGrid = intGrid.mapGrid { Character("\($0)") }

    #expect(charGrid.width == intGrid.width)
    #expect(charGrid.height == intGrid.height)

    #expect(charGrid.row(0) == ["1", "2", "3"])
    #expect(charGrid.row(1) == ["4", "5", "6"])
  }

  @Test("mapGrid on 1x1 grid")
  func singleElementGrid() {
    let grid = Grid(rows: [[42]])
    let stringGrid = grid.mapGrid { "v\($0)" }

    #expect(stringGrid.width == 1)
    #expect(stringGrid.height == 1)
    #expect(stringGrid.row(0) == ["v42"])
  }
}
