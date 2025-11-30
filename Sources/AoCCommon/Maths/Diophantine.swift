import Foundation

/// Solve the 2×2 linear Diophantine system:
///
///   ax * m + bx * n = cx
///   ay * m + by * n = cy
///
/// using integer arithmetic.
///
/// This routine eliminates one variable and checks whether the resulting
/// divisibility conditions hold, returning an integer solution if it exists.
///
/// - Parameters:
///   - ax: Coefficient of `m` in the first equation.
///   - bx: Coefficient of `n` in the first equation.
///   - ay: Coefficient of `m` in the second equation.
///   - by: Coefficient of `n` in the second equation.
///   - cx: Right-hand side of the first equation.
///   - cy: Right-hand side of the second equation.
/// - Returns: A tuple `(m, n)` if an integer solution exists; otherwise `nil`.
public func diophantineEEA(
  ax: Int,
  bx: Int,
  ay: Int,
  by: Int,
  cx: Int,
  cy: Int
) -> (m: Int, n: Int)? {
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
