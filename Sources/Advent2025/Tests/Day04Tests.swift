//
//  Day04Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Day04Tests {
    @Test func sampleInput() async throws {
        let input = """
            ..@@.@@@@.
            @@@.@.@.@@
            @@@@@.@.@@
            @.@@@@..@.
            @@.@@@@.@@
            .@@@@@@@.@
            .@.@.@.@@@
            @.@@@.@@@@
            .@@@@@@@@.
            @.@.@@@.@.
            """
        
        let day = Day04(data: input)
        #expect(day.part1() == 13)
    }
    
    @Test func sampleInputPart2() async throws {
        let input = """
            ..@@.@@@@.
            @@@.@.@.@@
            @@@@@.@.@@
            @.@@@@..@.
            @@.@@@@.@@
            .@@@@@@@.@
            .@.@.@.@@@
            @.@@@.@@@@
            .@@@@@@@@.
            @.@.@@@.@.
            """
        
        let day = Day04(data: input)
        #expect(day.part2() == 43)
    }
}
