//
//  Day10Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day10Tests {
    let testData = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    @Test func part1() throws {
        let day = Day10(data: testData)
        #expect(day.part1() == 36)
    }

    @Test func part2() throws {
        let day = Day10(data: testData)
        #expect(day.part2() == 81)
    }
}
