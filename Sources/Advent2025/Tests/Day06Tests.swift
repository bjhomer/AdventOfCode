//
//  Day06Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Day06Tests {
    @Test func sampleInput() async throws {
        let input = """
            123 328  51 64 
             45 64  387 23 
              6 98  215 314
            *   +   *   +  
            """
        
        let day = Day06(data: input)
        #expect(day.part1() == 4277556)
    }
    
    @Test func sampleInputPart2() async throws {
        let input = """
            123 328  51 64 
             45 64  387 23 
              6 98  215 314
            *   +   *   +  
            """
        
        let day = Day06(data: input)
        #expect(day.part2() == 3263827)
    }
    
    @Test func testProblemOutput() {
        let p = Day06.Problem(numbers: [1, 2, 3], operation: .multiply)
        #expect(p.description == "1 * 2 * 3")
    }
}
