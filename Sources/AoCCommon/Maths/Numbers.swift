import Foundation

/// Extended Euclidean algorithm for integers.
///
/// Computes `g = gcd(a, b)` and integers `x` and `y` such that:
///
///   a * x + b * y = g
///
/// with `g` guaranteed to be non-negative.
///
/// - Parameters:
///   - a: First integer.
///   - b: Second integer.
/// - Returns: A tuple `(g, x, y)` where `g` is `gcd(a, b)` and
///   `a * x + b * y == g`.
public func extendedEuclid(_ a: Int, _ b: Int) -> (g: Int, x: Int, y: Int) {
  if b == 0 {
    // Ensure g is always non-negative
    let g = abs(a)
    let x = a >= 0 ? 1 : -1
    return (g, x, 0)
  } else {
    let (g, x1, y1) = extendedEuclid(b, a % b)
    let x = y1
    let y = x1 - (a / b) * y1
    return (g, x, y)
  }
}
