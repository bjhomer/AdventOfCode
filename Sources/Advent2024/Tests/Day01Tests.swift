//
//  Day00.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Testing
@testable import Advent2024

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    @Test
    func testPart1() async throws {
      let day = Day01(data: testData)
      #expect(day.part1() == 11)
    }

  @Test
  func testPart2() async throws {
    let day = Day01(data: testData)
    #expect(day.part2() == 31)
  }
}
