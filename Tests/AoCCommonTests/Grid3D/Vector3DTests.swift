import AoCCommon
import Testing

@Suite("Vector3D Tests")
struct Vector3DTests {
  @Test("Memberwise initializer stores coordinates")
  func memberwiseInitializerStoresCoordinates() {
    let vector = Vector3D(x: 1, y: 2, z: 3)

    #expect(vector.x == 1)
    #expect(vector.y == 2)
    #expect(vector.z == 3)
  }

  @Test("Array initializer stores coordinates in order")
  func arrayInitializerStoresCoordinates() {
    let vector = Vector3D([10, 20, 30])

    #expect(vector.x == 10)
    #expect(vector.y == 20)
    #expect(vector.z == 30)
  }

  @Test("Squared distance to self is zero")
  func squaredDistanceToSelfIsZero() {
    let vector = Vector3D(x: 5, y: -3, z: 7)

    #expect(vector.squaredDistanceTo(vector) == 0)
  }

  @Test("Squared distance is symmetric")
  func squaredDistanceIsSymmetric() {
    let a = Vector3D(x: 0, y: 0, z: 0)
    let b = Vector3D(x: 1, y: 2, z: 3)

    let ab = a.squaredDistanceTo(b)
    let ba = b.squaredDistanceTo(a)

    #expect(ab == ba)
    #expect(ab == 1 + 4 + 9) // 14
  }

  @Test("Description matches expected format")
  func descriptionMatchesExpectedFormat() {
    let vector = Vector3D(x: 7, y: 8, z: 9)

    #expect(vector.description == "[7, 8, 9]")
  }
}
