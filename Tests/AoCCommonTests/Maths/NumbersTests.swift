import Testing

import AoCCommon

@Suite("GCD Extended")
struct ExtendedEuclid {
  @Test(
    "GCDExtended, parameterised", arguments: [
      (30, 12, 6), // Basic
      (42, 0, 42),
      (15, 15, 15),
      (-30, -12, 6), // Edge Cases
      (-35, -15, 5),
      (101, 103, 1), // Large inputs
      (123_456, 789_012, 12),
      (13, 7, 1), // Spacial Cases
      (1, 77, 1),
      (81, 9, 9),
    ],
  )
  func extendedEuclidTests(inputs: (Int, Int, Int)) {
    let (a, b, expected) = inputs
    let (gcd, x, y) = extendedEuclid(a, b)
    #expect(gcd == expected)
    #expect(abs(a * x + b * y) == gcd)
  }
}

@Suite("Bubble Digits")
struct BubbleDigits {
  @Test("Bubble small number", arguments: [
    ([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 2, [9, 8]),
    ([8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1], 2, [9, 2]),
    ([9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1], 12, [9, 8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1]),
    ([8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9], 12, [8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 9]),
    ([2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8], 12, [4, 3, 4, 2, 3, 4, 2, 3, 4, 2, 7, 8]),
    ([8, 1, 8, 1, 8, 1, 9, 1, 1, 1, 1, 2, 1, 1, 1], 12, [8, 8, 8, 9, 1, 1, 1, 1, 2, 1, 1, 1]),
  ])
  func bubbleDigitsTests(input: ([Int], Int, [Int])) {
    let (inputList, length, expected) = input
    #expect(bubbleDigits(inputList, length: length) == expected)
  }
}

@Suite("Extensions on Array")
struct ArrayExtensions {
  @Test("Array.toInt()", arguments: [
    ([], 0),
    ([0], 0),
    ([1, 2, 3], 123),
  ])
  func testToInt(input: ([Int], Int)) async throws {
    let (list, expected) = input
    #expect(list.toInt() == expected)
  }
}
