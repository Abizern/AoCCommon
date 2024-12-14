import Testing

import AoCCommon

@Suite("Solve Linear Diophantine simultaneus equations")
struct LinearDiophantine {
  @Test("System with solution")
  func diophantineEEASystemWithSolution() throws {
    guard let result = diophantineEEA(ax: 94, bx: 22, ay: 34, by: 67, cx: 8400, cy: 5400)
    else {
      #expect(Bool(false), "This should not be nil")
      return
    }
    #expect(result.m == 80)
    #expect(result.n == 40)
  }

  @Test("System with no solutions")
  func diophantineEEASystemWithNoSolutions() throws {
    #expect(diophantineEEA(ax: 26, bx: 67, ay: 66, by: 21, cx: 12748, cy: 12176) == nil)
  }
}
