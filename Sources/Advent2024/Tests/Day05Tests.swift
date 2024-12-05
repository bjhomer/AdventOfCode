//
//  Day05Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Testing
@testable import Advent2024

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
struct Day54Tests {
    // Smoke test data provided in the challenge question
    let testData = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """

    @Test
    func testPart1() async throws {
      let day = Day05(data: testData)
      #expect(day.part1() == 143)
    }

    @Test
    func testPart2() async throws {
        let day = Day05(data: testData)
        #expect(day.part2() == 123)
    }

    @Test
    func testSorting1() async throws {
        let day = Day05(data: testData)

        let pageList = Day05.PageList("75,97,47,61,53")
        let sortedList = day.pageManager.sort(pageList)
        #expect(sortedList.pages == [97,75,47,61,53])
    }

    @Test
    func testSorting2() async throws {
        let day = Day05(data: testData)

        let pageList = Day05.PageList("61,13,29")
        let sortedList = day.pageManager.sort(pageList)
        #expect(sortedList.pages == [61,29,13])
    }

    @Test
    func testSorting3() async throws {
        let day = Day05(data: testData)

        let pageList = Day05.PageList("97,13,75,29,47")
        let sortedList = day.pageManager.sort(pageList)
        #expect(sortedList.pages == [97,75,47,29,13])
    }

}
