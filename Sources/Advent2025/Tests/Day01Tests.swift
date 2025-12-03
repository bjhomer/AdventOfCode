//
//  Day00.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Testing
@testable import Advent2025

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day01Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
    
    @Test
    func testPart1() async throws {
        let day = Day01(data: testData)
        #expect(day.part1() == 3)
    }
    
    @Test
    func testPart2() async throws {
        let day = Day01(data: testData)
        #expect(day.part2() == 6)
    }
    
    @Test
    func testWraparound() async throws {
        let day = Day01(data: "R1000")
        #expect(day.part2() == 10)
    }
}
