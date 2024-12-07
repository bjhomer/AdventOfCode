//
//  Day06.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Foundation
import AdventCore
import Algorithms

struct Day06: AdventDay {
    typealias Grid = AdventCore.Grid<Character>
    var grid: Grid

    init(data: String) {
        grid = Grid(data.lines)
    }

    func part1() -> Int {
        var currentIndex = grid.firstIndex(of: "^")!
        var currentDirection: Grid.Direction = .up
        var visitedIndices: Set<Grid.Index> = []

        while true {
            let line = grid.indices(from: currentIndex, direction: currentDirection)
                .prefix(while: { grid[$0] != "#"} )

            visitedIndices.formUnion(line)

            if grid.index(moved: currentDirection, from: line.last!) == nil {
                // We walked off the end
                break
            }
            else {
                currentDirection = currentDirection.rotated(.clockwise90)
                currentIndex = line.last!
            }
        }

        return visitedIndices.count
    }
}

