//
//  Day04.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Foundation
import AdventCore

struct Day04: AdventDay {
    typealias Grid = AdventCore.Grid<Character>
    var grid: Grid

    init(data: String) {
        grid = Grid(data.lines)
    }

    func part1() -> Int {
        var successCount = 0
        for index in grid.indices {
            guard grid[index] == "X" else { continue }
            for direction in Grid.Direction.allCases {
                if grid.hasString("XMAS", from: index, direction: direction) {
                    successCount += 1
                }
            }
        }
        return successCount
    }

    func part2() -> Int {
        var successCount = 0

    outer:
        for index in grid.indices {
            guard grid[index] == "A" else { continue }

            var xCount = 0
            for direction in Grid.Direction.diagonals {
                if let start = grid.index(moved: direction, from: index),
                   grid.hasString("MAS", from: start, direction: direction.inverse) {
                    xCount += 1
                }
                if xCount == 2 {
                    successCount += 1
                    continue outer
                }
            }
        }
        return successCount
    }
}

private extension Day04.Grid {
    func hasString(_ string: String, from index: Grid.Index, direction: Grid.Direction) -> Bool {
        self.hasSequence(string, from: index, direction: direction)
    }
}
