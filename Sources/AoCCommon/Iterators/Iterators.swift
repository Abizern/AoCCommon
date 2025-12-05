import Foundation

/// Repeatedly applies a transformation function to an initial value until the
/// result stabilises, or until a maximum number of iterations is reached.
///
/// This function is useful for modelling iterative processes such as cellular
/// automata, grid relaxation steps, optimisation loops, or any computation in
/// which repeated application of a function eventually reaches a fixed point.
///
/// The sequence begins with `start`. On each iteration, `step` is applied to the
/// current value to produce the next value. Iteration stops when either:
///
/// - the next value is equal to the current value (`next == current`), or
/// - `maxIterations` iterations have been performed.
///
/// The returned array always includes the initial value, and contains every
/// intermediate state up to and including the first stable state.
///
/// - Parameters:
///   - start: The initial value from which iteration begins.
///   - maxIterations: A safety cap on the number of iterations. Defaults to
///     `.max`, meaning unbounded unless stabilisation occurs.
///   - step: A closure that produces the next value in the sequence from the
///     current value.
/// - Returns: An array of values beginning with `start` and ending with the
///   first value equal to its predecessor, or the final value reached before
///   `maxIterations` is exhausted.
///
/// - Note: `T` must conform to `Equatable` so that stabilisation can be detected.
@inlinable
public func iterateUntilStable<T: Equatable>(
  _ start: T,
  maxIterations: Int = .max,
  step: (T) -> T,
) -> [T] {
  var result: [T] = [start]
  var current = start

  for _ in 0 ..< maxIterations {
    let next = step(current)
    if next == current { break }
    result.append(next)
    current = next
  }

  return result
}
