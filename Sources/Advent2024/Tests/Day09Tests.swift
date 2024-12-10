//
//  Day09Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day09Tests {
    let testData = "2333133121414131402"

    @Test func part1() throws {
        let day = Day09(data: testData)
        #expect(day.part1() == 1928)
    }

    @Test func part2() throws {
        let day = Day09(data: testData)
        #expect(day.part2() == 2858)
    }
}
