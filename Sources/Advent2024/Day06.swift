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

    func part2() -> Int {

        let startPoint = grid.firstIndex(of: "^")!

        var checkedPoints: Set<GridPoint> = []
        var loopingObstacles = 0

        var traveller: Grid.PathStep = .init(index: startPoint, direction: .up)

        while true {
            if checkedPoints.contains(traveller.index) == false,
               grid[traveller.index] != "^"
            {
                var modifiedGrid = grid
                modifiedGrid[traveller.index] = "#"

                if modifiedGrid.loops(from: startPoint) {
                    loopingObstacles += 1
                }
                checkedPoints.insert(traveller.index)
            }
            guard let nextPoint = grid.nextStep(for: traveller) else {
                break
            }
            traveller = nextPoint
        }

        return loopingObstacles
    }
}

private extension Day06.Grid {
    struct PathStep: Hashable {
        var index: Grid.Index
        var direction: Grid.Direction
    }

    func nextStep(for traveller: PathStep) -> PathStep? {
        guard let nextLocation = index(moved: traveller.direction, from: traveller.index)
        else {
            return nil
        }

        var newTraveller = traveller
        if self[nextLocation] == "#" {
            newTraveller.direction = traveller.direction.rotated(.clockwise90)
        }
        else {
            newTraveller.index = nextLocation
        }
        return newTraveller
    }

    func loops(from start: Grid.Index) -> Bool {
        var tortoise: PathStep? = PathStep(index: start, direction: .up)
        var hare: PathStep? = PathStep(index: start, direction: .up)

        while true {
            for _ in 0..<2 {
                hare = nextStep(for: hare!)
                if hare == nil {
                    // We found an exit; no loop here!
                    return false
                }
                if tortoise == hare {
                    // We looped
                    return true
                }
            }
            tortoise = nextStep(for: tortoise!)
        }
        return false
    }
}

private extension Day06.Grid.Direction {
    var character: Character {
        switch self {
        case .up: return "^"
        case .right: return ">"
        case .down: return "v"
        case .left: return "<"
        default: fatalError()
        }
    }
}
