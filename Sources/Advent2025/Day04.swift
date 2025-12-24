//
//  Day04.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import AdventCore

struct Day04: AdventDay {
    var grid: Grid<Character>
    
    init(data: String) {
        grid = Grid(data.lines)
    }
    
    func part1() -> Int {
        grid
            .indices
            .filter { grid[$0] == "@" }
            .map { point in
                grid.surroundingValues(of: point)
                    .count(where: { $0 == "@" })
            }
            .count(where: { $0 < 4 })
    }
    
    func part2() -> Int {
        var currentGrid = grid
        var removedRolls = 0
        
        while true {
            let removablePoints = grid
                .indices
                .filter { point in
                    currentGrid[point] == "@" &&
                    currentGrid.surroundingValues(of: point)
                        .count(where: { $0 == "@" }) < 4
                }
            if removablePoints.count == 0 {
                break
            }
            for point in removablePoints {
                currentGrid[point] = "."
            }
            removedRolls += removablePoints.count
        }
        return removedRolls
    }
}

extension Grid {
    func surroundingValues(of point: Index) -> [T] {
        surroundingNeighbors(of: point)
            .map { self[$0] }
    }
}
