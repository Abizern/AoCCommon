import Testing

@testable import AoCCommon

@Suite("Transposition Tests")
struct TranspositionTests {
  @Test("Transpose a matrix in row-major order")
  func transposeMatrixInRowMajorOrder() {
    let input: [[Int]] = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]
    let expectation: [[Int]] = [
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
    ]

    #expect(transpose(input) == expectation)
  }
}
