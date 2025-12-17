//
//  Day02Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/25.
//

import Testing
@testable import Advent2025

struct Test {

    @Test func test11_22() async throws {
        let ids = Day02.IDRange(range: 11...22).invalidIDs
        
        #expect(ids == [11, 22])
    }
    
    @Test func sampleRanges() async throws {
        let rangesAndAnswers: [ClosedRange<Int>: [Int]] = [
            (11...22) : [11, 22],
            (95...115) :  [99],
            (998...1012) :  [1010],
            (1188511880...1188511890) : [1188511885],
            (222220...222224) :  [222222],
            (1698522...1698528) : [],
            (446443...446449) :  [446446],
            (38593856...38593862) :  [38593859],
        ]
        
        for (range, expectedIDs) in rangesAndAnswers {
            let ids = Day02.IDRange(range: range).invalidIDs
            #expect(ids == expectedIDs)
        }
    }
    
    @Test func testSample_part1() async throws {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124\n"
        let day = Day02(data: input)
        #expect(day.part1() == 1227775554)
    }
    
    @Test func testSample_part2() async throws {
        let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124\n"
        let day = Day02(data: input)
        #expect(day.part2() == 4174379265)
    }

}
