import Testing

@testable import AoCCommon

@Suite("Matrix transposition")
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

@Suite("Matrix rotation")
struct RotationTests {
  @Test("Rotate clockwise")
  func rotateClockwise() {
    let input: [[Int]] = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]
    let expectation: [[Int]] = [
      [7, 4, 1],
      [8, 5, 2],
      [9, 6, 3],
    ]
    #expect(rotateRight(input) == expectation)
  }
}

@Suite("Matrix flipping")
struct FlippingTests {
  @Test("Flip vertically")
  func flipMatrixVertically() {
    let input: [[Int]] = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 9, 8],
    ]
    let expectation: [[Int]] = [
      [3, 2, 1],
      [6, 5, 4],
      [8, 9, 7],
    ]
    #expect(flipVertically(input) == expectation)
  }
}
