//
//  Day08Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day08Tests {

    let testData1 = """
    ..........
    ...#......
    ..........
    ....a.....
    ..........
    .....a....
    ..........
    ......#...
    ..........
    ..........
    """

    @Test func testTwoNodes() async throws {
        let day = Day08(data: testData1)
        let antinodeLocations = day.sortedAntinodes(mode: .part1)

        let expectedNode1 = GridPoint(r: 1, c: 3)
        let expectedNode2 = GridPoint(r: 7, c: 6)

        #expect(antinodeLocations == [expectedNode1, expectedNode2])
    }

    let testData2 = """
    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......#...
    ..........
    ..........
    """

    @Test func testThreeNodes() async throws {
        let day = Day08(data: testData2)
        let antinodeLocations = day.sortedAntinodes(mode: .part1)

        let expectedNodes: [GridPoint] = [
            .init(r: 1, c: 3),
            .init(r: 2, c: 0),
            .init(r: 6, c: 2),
            .init(r: 7, c: 6),
        ]

        #expect(antinodeLocations == expectedNodes)
    }

    let testData3 = """
    ..........
    ...#......
    #.........
    ....a.....
    ........a.
    .....a....
    ..#.......
    ......A...
    ..........
    ..........
    """

    @Test func testAntinodesOverlappingAntenna() async throws {
        let day = Day08(data: testData2)
        let antinodeLocations = day.sortedAntinodes(mode: .part1)

        let expectedNodes: [GridPoint] = [
            .init(r: 1, c: 3),
            .init(r: 2, c: 0),
            .init(r: 6, c: 2),
            .init(r: 7, c: 6),
        ]

        #expect(antinodeLocations == expectedNodes)
    }

    let testData4 = """
    ......#....#
    ...#....0...
    ....#0....#.
    ..#....0....
    ....0....#..
    .#....A.....
    ...#........
    #......#....
    ........A...
    .........A..
    ..........#.
    ..........#.
    """

    @Test func testComplex() async throws {
        let day = Day08(data: testData4)
        let antinodeLocations = day.sortedAntinodes(mode: .part1)

        let expectedNodes: [GridPoint] = [
            .init(r: 0, c: 6),
            .init(r: 0, c: 11),
            .init(r: 1, c: 3),
            .init(r: 2, c: 4),
            .init(r: 2, c: 10),
            .init(r: 3, c: 2),
            .init(r: 4, c: 9),
            .init(r: 5, c: 1),
            .init(r: 5, c: 6),
            .init(r: 6, c: 3),
            .init(r: 7, c: 0),
            .init(r: 7, c: 7),
            .init(r: 10, c: 10),
            .init(r: 11, c: 10),
        ]

        #expect(antinodeLocations == expectedNodes)
    }

    @Test func testPart1() async throws {
        let day = Day08(data: testData4)
        #expect(day.part1() == 14)
    }

    @Test func testPart2() async throws {
        let day = Day08(data: testData4)
        #expect(day.part2() == 34)
    }
}
