import Foundation

/// Solve the Linear Diophantine System
/// ax * m + bx * m = cx
/// ay * m + by * n = cy
///
/// Uses the Extended Euclid Algorithm
public func diophantineEEA(ax: Int, bx: Int, ay: Int, by: Int, cx: Int, cy: Int) -> (m: Int, n: Int)? {
  let aPrime = ay * bx - by * ax
  let cPrime = cy * bx - by * cx

  if aPrime == 0 || cPrime % aPrime != 0 {
    return nil
  }

  let m = cPrime / aPrime

  let numerator = cx - ax * m
  if numerator % bx != 0 {
    return nil
  }

  let n = numerator / bx

  return (m, n)
}
