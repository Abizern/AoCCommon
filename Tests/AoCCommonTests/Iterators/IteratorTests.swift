import Testing

@testable import AoCCommon

@Suite("iterateUntilStable")
struct IterateUntilStableTests {
  @Test("Sequence evolves until stable")
  func evolvesUntilStable() {
    // f(x) = min(x + 1, 3)
    let result = iterateUntilStable(0) { min($0 + 1, 3) }

    // Expected: 0 → 1 → 2 → 3 → stop (3 == 3)
    #expect(result == [0, 1, 2, 3])
  }

  @Test("Immediate stability produces a single-element array")
  func immediateStability() {
    let result = iterateUntilStable(42) { $0 } // identity function
    #expect(result == [42])
  }

  @Test("Stops when maxIterations is reached")
  func respectsMaxIterations() {
    // f(x) = x + 1 (never stabilises)
    let result = iterateUntilStable(0, maxIterations: 3) { $0 + 1 }

    // Should include: start + 3 steps
    #expect(result == [0, 1, 2, 3])
  }

  @Test("Works for non-numeric types")
  func worksForStrings() {
    // Append "a" until length reaches 3
    let result = iterateUntilStable("a") {
      $0.count < 3 ? ($0 + "a") : $0
    }

    #expect(result == ["a", "aa", "aaa"])
  }

  @Test("Produces all intermediate states")
  func tracksIntermediateStates() {
    // f(x) = x / 2 until it becomes 1
    let result = iterateUntilStable(32) { max($0 / 2, 1) }

    #expect(result == [32, 16, 8, 4, 2, 1])
  }
}
