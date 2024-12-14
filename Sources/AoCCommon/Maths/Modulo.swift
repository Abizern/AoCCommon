import Foundation

// Real modulo function. Negative numbers wrap around.
public func mod(_ x: Int, _ n: Int) -> Int {
  ((x % n) + n) % n
}
