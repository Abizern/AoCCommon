import Collections
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
@inlinable
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

/// Collect the digits in the number to create the largest number of a given length, preserving order
///
/// For example:
/// ```swift
/// bubbleDigits([9,8,7,6,5,4,3,2,1,1,1,1,1,1,1], length: 2) // [9, 8]
/// bubbleDigits([9,8,7,6,5,4,3,2,1,1,1,1,1,1,1], length: 12) // [9,8,7,6,5,4,3,2,1,1,1,1]
/// ```
///
/// Created for 2025 Day 3
///
/// - Parameters:
///   - numbers: The list of digits to be processed
///   - length: The number of digits to extract, Must be less than on equal to the number of input digits
/// - Returns: The extracted digits
@inlinable
public func bubbleDigits(_ numbers: [Int], length: Int) -> [Int] {
  let inputLength = numbers.count
  var numberOfDrops = inputLength - length
  precondition(numberOfDrops >= 0, "Can't drop more digits than there are numbers")

  var stack = Deque<Int>(minimumCapacity: inputLength)

  for number in numbers {
    while numberOfDrops > 0, let last = stack.last, last < number {
      stack.removeLast()
      numberOfDrops -= 1
    }
    stack.append(number)
  }

  return Array(stack.prefix(length))
}

public extension [Int] {
  /// Turns an array of Integers into a decimal number
  ///
  /// ```swift
  /// [1, 2, 3].toInt() // -> 123
  ///
  /// - Returns: an Integer form from the digits in the array
  @inlinable
  func toInt() -> Int {
    reduce(into: 0) { result, digit in
      result = result * 10 + digit
    }
  }
}
