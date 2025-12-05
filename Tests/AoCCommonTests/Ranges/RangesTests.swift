import Testing

@testable import AoCCommon

@Suite("Merge a Sequence of ranges")
struct MergeRangesTests {
  @Test("Non overlapping sequence unchanged")
  func nonOverlappingRangesUnchanged() {
    let sequence: [ClosedRange<Int>] = [3 ... 5, 6 ... 10]
    #expect(sequence.merged() == sequence)
  }

  @Test("Overlapping ranges are merged")
  func overlappingRangesMerged() {
    let sequence: [ClosedRange<Int>] = [
      3 ... 5,
      10 ... 14,
      16 ... 20,
      12 ... 18,
    ]

    let expectation: [ClosedRange<Int>] = [
      3 ... 5,
      10 ... 20,
    ]

    #expect(sequence.merged() == expectation)
  }
}
