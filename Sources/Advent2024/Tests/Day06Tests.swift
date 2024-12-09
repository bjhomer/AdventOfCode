//
//  Day06Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Testing
@testable import Advent2024

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day06Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """

    @Test
    func testPart1() async throws {
        let day = Day06(data: testData)
        #expect(day.part1() == 41)
    }

    @Test
    func testPart2() async throws {
        let day = Day06(data: testData)
        #expect(day.part2() == 6)
    }
}
