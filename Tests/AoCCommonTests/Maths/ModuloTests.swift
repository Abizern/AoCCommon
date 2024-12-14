import Testing

import AoCCommon

@Suite("Real Modulo function")
struct RealModulo {
  @Test("mod function")
  func realModulo() {
    #expect(mod(10, 10) == 0)
    #expect(mod(13, 10) == 3)
    #expect(mod(-10, 10) == 0)
    #expect(mod(-2, 10) == 8)
  }
}
