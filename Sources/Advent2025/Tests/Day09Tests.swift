//
//  Day09Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Day09Tests {
    @Test func sampleInput() async throws {
        let input = """
            7,1
            11,1
            11,7
            9,7
            9,5
            2,5
            2,3
            7,3
            """
        
        let day = Day09(data: input)
        #expect(day.part1() == 50)
    }
    
    @Test func sampleInputPart2() async throws {
        let input = """
            7,1
            11,1
            11,7
            9,7
            9,5
            2,5
            2,3
            7,3
            """
        
        let day = Day09(data: input)
        #expect(day.part2() == 25272)
    }
}
