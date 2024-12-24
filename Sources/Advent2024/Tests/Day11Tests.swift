//
//  Day11Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day11Tests {
    let testData = "125 17"

    @Test func part1() throws {
        let day = Day11(data: testData)
        #expect(day.part1() == 55312)
    }

    @Test func testDescriptionValue() throws {
        let stone = Day11.StoneNode.value(3)
        #expect(stone.description == "3")
    }

    @Test func testDescriptionSplit() throws {
        let stone = Day11.StoneNode.split(.value(3), .split(.value(4), .value(5)))
        #expect(stone.description == "3 4 5")
    }
}
