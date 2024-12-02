//
//  Day00.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Testing
@testable import AdventOfCode2024

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day02Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """

    @Test
    func testPart1() async throws {
      let day = Day02(data: testData)
      #expect(day.part1() == 2)
    }

  @Test
  func testPart2() async throws {
      let day = Day02(data: testData)
      #expect(day.part2() == 4)
  }
}
