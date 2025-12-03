import Foundation

/// A true mathematical modulo operation on integers.
///
/// Swift’s `%` operator is a remainder; for negative values it can produce a
/// negative result. This function wraps negative values so that the result is
/// always in the range `0 ..< n`.
///
/// - Parameters:
///   - x: The value to reduce.
///   - n: The modulus. Assumed to be non-zero.
/// - Returns: The unique integer `r` such that `0 <= r < |n|` and
///   `r ≡ x (mod n)`.
@inlinable
public func mod(_ x: Int, _ n: Int) -> Int {
  ((x % n) + n) % n
}
