import Foundation

/// A simple three-dimensional integer vector.
///
/// `Vector3D` stores an `(x, y, z)` coordinate using integer values
/// and provides basic spatial operations such as computing squared
/// Euclidean distance. It is hashable and can therefore be used as
/// a dictionary key or stored in sets.
///
/// This type is intentionally lightweight and does not impose any
/// particular coordinate system or units; it is commonly used for
/// Advent of Code puzzles involving 3D points, grids, or spatial
/// relationships.
///
public struct Vector3D: Hashable {
  // MARK: - Stored Properties

  /// The x-coordinate of the vector.
  public let x: Int

  /// The y-coordinate of the vector.
  public let y: Int

  /// The z-coordinate of the vector.
  public let z: Int

  // MARK: - Initializers

  /// Creates a new 3D vector from individual `x`, `y`, and `z` components.
  ///
  /// - Parameters:
  ///   - x: The x-coordinate.
  ///   - y: The y-coordinate.
  ///   - z: The z-coordinate.
  public init(x: Int, y: Int, z: Int) {
    self.x = x
    self.y = y
    self.z = z
  }

  /// Creates a new 3D vector from a list of exactly three integers.
  ///
  /// The integers must appear in the order `[x, y, z]`.
  /// A runtime precondition is enforced to ensure the list contains
  /// exactly three values.
  ///
  /// - Parameter list: A three-element array containing the
  ///   coordinates `[x, y, z]`.
  public init(_ list: [Int]) {
    precondition(list.count == 3, "Vector3D requires exactly 3 integers.")
    self = .init(x: list[0], y: list[1], z: list[2])
  }

  // MARK: - Distance Calculation

  /// Returns the squared Euclidean distance from this point to another.
  ///
  /// This avoids computing a square root and is therefore useful in
  /// situations where only relative distances matter, such as
  /// comparing which of several points is closest.
  ///
  /// - Parameter other: The point to measure distance to.
  /// - Returns: The squared distance `(dx² + dy² + dz²)`.
  public func squaredDistanceTo(_ other: Vector3D) -> Int {
    let dx = x - other.x
    let dy = y - other.y
    let dz = z - other.z
    return dx * dx + dy * dy + dz * dz
  }
}

// MARK: - CustomStringConvertible

extension Vector3D: CustomStringConvertible {
  /// A textual representation of the vector in the form `[x, y, z]`.
  public var description: String {
    "[\(x), \(y), \(z)]"
  }
}
