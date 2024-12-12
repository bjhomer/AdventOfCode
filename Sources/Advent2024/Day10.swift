//
//  Day10.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/12/24.
//

import Foundation
import AdventCore

struct Day10: AdventDay {
    typealias Grid = AdventCore.Grid<Int>
    var grid: Grid

    init(data: String) {
        let ints = data.lines.map { $0.map(\.forceInt) }
        grid = Grid(ints)
    }

    func part1()  -> Int {

        var trailheadCount = 0
        for index in grid.indices {
            let result = peaksReachable(from: index)
            if result.count > 0 {
                trailheadCount += result.count
            }
        }
        return trailheadCount
    }

    func part2()  -> Int {
        var trailheadCount = 0
        for index in grid.indices {
            let result = ascendingPaths(from: index)
            if result > 0 {
                trailheadCount += result
            }
        }
        return trailheadCount
    }

    func peaksReachable(from index: Grid.Index, startValue: Int = 0) -> Set<Grid.Index> {
        guard grid[index] == startValue else {
            return []
        }

        if startValue == 9 {
            return [index]
        }

        return grid.cardinalNeighbors(of: index)
            .map { peaksReachable(from: $0, startValue: startValue + 1) }
            .reduce(into: Set(), { $0.formUnion($1) })
    }

    func ascendingPaths(from index: Grid.Index, startValue: Int = 0) -> Int {
        guard grid[index] == startValue else {
            return 0
        }

        if startValue == 9 {
            return 1
        }

        return grid.cardinalNeighbors(of: index)
            .map { ascendingPaths(from: $0, startValue: startValue + 1) }
            .reduce(0, +)
    }
}
