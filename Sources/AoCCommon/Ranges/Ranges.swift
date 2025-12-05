import Foundation

public extension Sequence<ClosedRange<Int>> {
  /// Merge overlapping ranges.
  ///
  /// Only true overlaps are merged:
  /// `3...5` and `6...10` stay separate.
  ///
  /// - Returns: A sorted list of merged non-overlapping ranges.
  @inlinable
  func merged() -> [ClosedRange<Int>] {
    let sorted = sorted { $0.lowerBound < $1.lowerBound }
    guard var current = sorted.first else { return [] }

    var result: [ClosedRange<Int>] = []

    for range in sorted.dropFirst() {
      if current.overlaps(range) {
        // They overlap: extend the end if needed
        current = current.lowerBound ... Swift.max(current.upperBound, range.upperBound)
      } else {
        // They don't: commit and start a new range
        result.append(current)
        current = range
      }
    }

    result.append(current)
    return result
  }
}
