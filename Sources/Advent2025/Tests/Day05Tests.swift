//
//  Day05Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Day05Tests {
    @Test func sampleInput() async throws {
        let input = """
            3-5
            10-14
            16-20
            12-18

            1
            5
            8
            11
            17
            32
            """
        
        let day = Day05(data: input)
        #expect(day.part1() == 3)
    }
    
    @Test func sampleInputPart2() async throws {
        let input = """
            3-5
            10-14
            16-20
            12-18

            1
            5
            8
            11
            17
            32
            """
        
        let day = Day05(data: input)
        #expect(day.part2() == 14)
    }
}
