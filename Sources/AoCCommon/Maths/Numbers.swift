import Foundation

/// Extended Euclidean Algorithm
/// Returns (g, x, y) such that a*x + b*y = g = gcd(a, b)
public func extendedEuclid(_ a: Int, _ b: Int) -> (g: Int, x: Int, y: Int) {
  if b == 0 {
    return (a, 1, 0)
  } else {
    let (g, x1, y1) = extendedEuclid(b, a % b)
    return (g, y1, x1 - (a / b) * y1)
  }
}
