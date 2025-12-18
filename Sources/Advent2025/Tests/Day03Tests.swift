//
//  Day03Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Day03Tests {
    @Test func sampleInput() async throws {
        let input = """
            987654321111111
            811111111111119
            234234234234278
            818181911112111
            """
        
        let day = Day03(data: input)
        #expect(day.part1() == 357)
    }
    
    @Test func sampleInputPart2() async throws {
        let input = """
            987654321111111
            811111111111119
            234234234234278
            818181911112111
            """
        
        let day = Day03(data: input)
        #expect(day.part2() == 3121910778619)
    }
}
