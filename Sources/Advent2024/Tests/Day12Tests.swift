//
//  Day12Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day12Tests {
    let testData1 = """
    AAAA
    BBCD
    BBCC
    EEEC
    """

    let testData2 = """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """

    let testData3 = """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """

    @Test func testPerimeter() {
        let region = Day12.Region(name: "A", points: [
            .init(r: 0, c: 0),
            .init(r: 0, c: 1),
            .init(r: 0, c: 2),
            .init(r: 0, c: 3),
        ])

        #expect(region.perimeter == 10)
    }

    @Test func test1_part1() throws {
        let day = Day12(data: testData1)
        #expect(day.part1() == 140)
    }

    @Test func test2_part1() throws {
        let day = Day12(data: testData2)
        #expect(day.part1() == 772)
    }

    @Test func test3_part1() throws {
        let day = Day12(data: testData3)
        #expect(day.part1() == 1930)
    }
}
