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
      (123456, 789012, 12),
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
