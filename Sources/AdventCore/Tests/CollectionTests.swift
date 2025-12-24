//
//  CollectionTests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/9/24.
//

import Testing
@testable import AdventCore

struct CollectionTests {

    @Test func combinationsWithReplacement() async throws {
        let a = [6, 7, 8]

        let combinations = a.combinationsWithReplacement(count: 2)

        let expectedResult = [
            [6, 6],
            [6, 7],
            [6, 8],
            [7, 6],
            [7, 7],
            [7, 8],
            [8, 6],
            [8, 7],
            [8, 8],
        ]

        #expect(combinations.elementsEqual(expectedResult))
    }

    @Test func combinationsWithReplacement3() async throws {
        let a = [6, 7]

        let combinations = a.combinationsWithReplacement(count: 3)

        let expectedResult = [
            [6, 6, 6],
            [6, 6, 7],
            [6, 7, 6],
            [6, 7, 7],
            [7, 6, 6],
            [7, 6, 7],
            [7, 7, 6],
            [7, 7, 7],
        ]

        #expect(Array(combinations) == expectedResult)
    }

    @Test func emptyCombinationsWithReplacement() async throws {
        let a: [Int] = []
        
        let combinations = a.combinationsWithReplacement(count: 2)
        
        #expect(Array(combinations).isEmpty)
    }

    @Test func combinationsWithReplacementIndexingNoWrap() async throws {
        let base = ["a", "b"]
        let seq = CombinationsWithReplacementSequence(base: base, count: 3)

        var index = [0, 0, 0]
        seq.increment(&index)
        #expect(index == [0, 0, 1])
    }

    @Test func combinationsWithReplacementIndexingWrapFirstIndex() async throws {
        let base = ["a", "b"]
        let seq = CombinationsWithReplacementSequence(base: base, count: 3)

        var index = [0, 0, 1]
        seq.increment(&index)
        #expect(index == [0, 1, 0])
    }

    @Test func combinationsWithReplacementIndexingWrapSecondIndex() async throws {
        let base = ["a", "b"]
        let seq = CombinationsWithReplacementSequence(base: base, count: 3)

        var index = [0, 1, 1]
        seq.increment(&index)
        #expect(index == [1, 0, 0])
    }

    @Test func combinationsWithReplacementIndexingWrapLastIndex() async throws {
        let base = ["a", "b"]
        let seq = CombinationsWithReplacementSequence(base: base, count: 3)

        var index = [1, 1, 1]
        seq.increment(&index)
        #expect(index == [2, 0, 0])
    }
    
    @Test func testZip() {
        let s1 = [1, 2, 3]
        let s2 = [10, 20, 30]
        let s3 = [-1, -2, -3]
        
        let result = zipSequences([s1, s2, s3])
        
        #expect(result[0] == [1, 10, -1])
        #expect(result[1] == [2, 20, -2])
        #expect(result[2] == [3, 30, -3])
    }

}
