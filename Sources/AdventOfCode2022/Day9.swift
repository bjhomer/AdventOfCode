//
//  Day9.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import Algorithms
import AdventCore

struct Day9: Day {

    private var movements: [Movement]

    init(input: URL) async throws {
        movements = try input.allLines.compactMap { Movement($0) }
    }
    
    func part1() async {
        var tailPositions: Set<Position> = []

        let start = Position(row: 0, column: 0)
        var rope = RopeSegment(position: start)

        tailPositions.insert(rope.tail)
        for movement in movements {
            for smallMovement in movement.incrementalMovements {
                rope.moveHead(smallMovement)
                tailPositions.insert(rope.tail)
            }
        }

        let result = tailPositions.count
        print(result)
    }
    
    func part2() async {
        var tailPositions: Set<Position> = []

        let start = Position(row: 0, column: 0)
        var rope = Rope(position: start, knotCount: 10)

        tailPositions.insert(rope.tail)
        for movement in movements {
            for smallMovement in movement.incrementalMovements {
                rope.moveHead(smallMovement)
                tailPositions.insert(rope.tail)
            }
        }

        let result = tailPositions.count
        print(result)
    }
}

private struct Position: Hashable {
    var row: Int
    var column: Int

    func gridDistance(to other: Position) -> Int {
        return max(abs(row - other.row), abs(column - other.column))
    }

    mutating func move(by movement: Movement) {
        switch movement.direction {
        case .up: row -= movement.distance
        case .down: row += movement.distance
        case .left: column -= movement.distance
        case .right: column += movement.distance
        }
    }
}

private struct Movement {
    enum Direction {
        case up, down, left, right
    }

    var direction: Direction
    var distance: Int

    var incrementalMovements: [Movement] {
        Array(repeating: Movement(direction: direction, distance: 1), count: self.distance)
    }
}

extension Movement {
    init?(_ str: some StringProtocol) {
        guard let (dir, amount) = str.split(separator: " ").explode()
        else { return nil }

        switch dir {
        case "R": direction = .right
        case "L": direction = .left
        case "U": direction = .up
        case "D": direction = .down
        default: fatalError()
        }

        distance = Int(String(amount))!

    }
}

private struct Rope {
    // Head first
    var knots: [Position]

    var head: Position { knots.first! }
    var tail: Position { knots.last! }

    init(position: Position, knotCount: Int) {
        knots = Array(repeating: position, count: knotCount)
    }

    mutating func moveHead(_ movement: Movement) {
        knots[0].move(by: movement)

        for (i, j) in knots.indices.adjacentPairs() {
            var segment = RopeSegment(head: knots[i], tail: knots[j])
            segment.resolveTail()
            knots[j] = segment.tail
        }
    }
}

private struct RopeSegment {

    var head: Position
    var tail: Position

    init(head: Position, tail: Position) {
        self.head = head
        self.tail = tail
    }

    init(position: Position) {
        head = position
        tail = position
    }

    mutating func moveHead(_ movement: Movement) {
        head.move(by: movement)
        resolveTail()
    }

    mutating func resolveTail() {
        if head.gridDistance(to: tail) > 1 {
            let deltaR = head.row - tail.row
            let deltaC = head.column - tail.column

            tail.column += deltaC.signum()
            tail.row += deltaR.signum()
        }
    }
}
