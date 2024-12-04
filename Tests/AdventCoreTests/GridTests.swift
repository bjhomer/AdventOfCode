//
//  GridTests.swift
//  
//
//  Created by BJ Homer on 12/12/23.
//

import XCTest
import AdventCore

final class GridTests: XCTestCase {

    typealias G = Grid<Character>
    var grid: G!

    override func setUpWithError() throws {
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

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLastIndexInDirection() throws {
        let start = G.Index(r: 0, c: 2)

        let leftExtent = grid.lastIndex(from: start, direction: .left, satisfying: { grid[$0].isWholeNumber })
        XCTAssertEqual(leftExtent, G.Index(r: 0, c: 0))

        let rightExtent = grid.lastIndex(from: start, direction: .right, satisfying: { grid[$0].isWholeNumber })
        XCTAssertEqual(rightExtent, G.Index(r: 0, c: 2))
    }

    func testValuesInDirection() throws {
        let start = G.Index(r: 0, c: 2)
        
        let values = grid.values(from: start, direction: .down, limit: 4)
        XCTAssertEqual(values, ["7", ".", "3", "."])
    }

    func testIndices() throws {
        let indices = grid.indices
        XCTAssertEqual(indices.count, 100)
    }
}
