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
        var currentIndex = startPoint
        var currentDirection: Grid.Direction = .up

        let locationsOnExitPath = Set(grid.stepsToExit()!.map(\.index))
        var checkedPoints: Set<GridPoint> = []
        var loopingObstacles: Set<GridPoint> = []

        while true {
            let walkedLine = grid.indices(from: currentIndex, direction: currentDirection)
                .prefix(while: { grid[$0] != "#"} )

            for point in walkedLine {
                guard locationsOnExitPath.contains(point) else {
                    // The path never crosses here; an obstacle
                    // here will not have any effect
                    continue
                }
                if checkedPoints.contains(point) {
                    continue
                }
                if grid[point] == "^" {
                    continue
                }
                var modifiedGrid = grid
                modifiedGrid[point] = "#"

                if modifiedGrid.loops(from: startPoint) {
                    loopingObstacles.insert(point)
                }
                checkedPoints.insert(point)
            }

            if grid.index(moved: currentDirection, from: walkedLine.last!) == nil {
                // We walked off the end
                break
            }
            else {
                currentDirection = currentDirection.rotated(.clockwise90)
                currentIndex = walkedLine.last!
            }
        }

        return loopingObstacles.count
    }
}

private extension Day06.Grid {
    struct PathStep: Hashable {
        let index: Grid.Index
        let direction: Grid.Direction
    }

    func loops(from start: Grid.Index) -> Bool {

        var currentIndex = start
        var currentDirection: Grid.Direction = .up
        var visitedSteps: Set<PathStep> = []

        while true {
            let line = indices(from: currentIndex, direction: currentDirection)
                .prefix(while: { self[$0] != "#"} )

            let steps = line.map { PathStep(index: $0, direction: currentDirection)}
            for step in steps {
                if visitedSteps.contains(step) {
                    // we found a loop!
                    return true
                }
            }

            visitedSteps.formUnion(steps)

            if index(moved: currentDirection, from: line.last!) == nil {
                // We walked off the end
                break
            }
            else {
                currentDirection = currentDirection.rotated(.clockwise90)
                currentIndex = line.last!
            }
        }
        return false
    }

    func stepsToExit() -> [Grid.PathStep]? {

        var currentIndex = firstIndex(of: "^")!
        var currentDirection: Grid.Direction = .up
        var visitedSteps: [Grid.PathStep] = []

        while true {
            let line = indices(from: currentIndex, direction: currentDirection)
                .prefix(while: { self[$0] != "#"} )

            let steps = line.map { Grid.PathStep(index: $0, direction: currentDirection)}

            for step in steps {
                if visitedSteps.contains(step) {
                    // we found a loop!
                    return nil
                }
            }

            visitedSteps.append(contentsOf: steps)

            if index(moved: currentDirection, from: line.last!) == nil {
                // We walked off the end
                break
            }
            else {
                currentDirection = currentDirection.rotated(.clockwise90)
                currentIndex = line.last!
            }
        }

        return visitedSteps
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
