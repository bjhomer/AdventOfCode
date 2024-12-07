//
//  GridTests.swift
//  
//
//  Created by BJ Homer on 12/12/23.
//

import Testing
import AdventCore


struct GridTests {

    typealias G = Grid<Character>
    var grid: G!

    init() {
        let input = """
        467..114..
        ...*......
        ..35..633.
        ......#...
        617*......
        .....+.58.
        ..592.....
        ......755.
        ...$.*....
        .664.598..
        """
        grid = Grid(input.lines)
    }

    @Test
    func testLastIndexInDirection() throws {
        let start = G.Index(r: 0, c: 2)

        let leftExtent = grid.lastIndex(from: start, direction: .left, satisfying: { grid[$0].isWholeNumber })
        #expect(leftExtent == G.Index(r: 0, c: 0))

        let rightExtent = grid.lastIndex(from: start, direction: .right, satisfying: { grid[$0].isWholeNumber })
        #expect(rightExtent == G.Index(r: 0, c: 2))
    }

    @Test
    func testValuesInDirection() throws {
        let start = G.Index(r: 0, c: 2)
        
        let values = grid.values(from: start, direction: .down, limit: 4)
        #expect(values == ["7", ".", "3", "."])
    }

    @Test
    func testHasSequenceInDirection() throws {
        let start = G.Index(r: 0, c: 2)
        
        #expect(grid.hasSequence("7.3.", from: start, direction: .down))
        #expect(!grid.hasSequence("7.3.", from: start, direction: .up))
        #expect(!grid.hasSequence("7.3.", from: start, direction: .left))
        #expect(!grid.hasSequence("7.3.", from: start, direction: .right))

        #expect(grid.hasSequence("7..11", from: start, direction: .right))
    }

    @Test
    func testIndices() throws {
        let indices = grid.indices
        #expect(indices.count == 100)
    }

    @Test
    func testDirectionRotation() throws {
        #expect(G.Direction.up.rotated(.clockwise45) == .upRight)
        #expect(G.Direction.up.rotated(.clockwise90) == .right)
        #expect(G.Direction.up.rotated(.counterClockwise45) == .upLeft)
        #expect(G.Direction.up.rotated(.counterClockwise90) == .left)
    }

    @Test
    func testIndexDirectionSequence() throws {
        let start = G.Index(r: 0, c: 2)

        let expectedResult: [G.Index] = [
            .init(r: 0, c: 2),
            .init(r: 1, c: 3),
            .init(r: 2, c: 4),
            .init(r: 3, c: 5),
            .init(r: 4, c: 6),
            .init(r: 5, c: 7),
            .init(r: 6, c: 8),
            .init(r: 7, c: 9),
        ]

        let sequence = grid.indices(from: start, direction: .downRight)

        #expect(sequence.elementsEqual(expectedResult))
    }
}
