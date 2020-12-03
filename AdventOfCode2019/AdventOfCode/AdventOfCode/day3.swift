//
//  day3.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/19.
//  Copyright © 2019 Bloom Built, Inc. All rights reserved.
//

import Foundation

private let sampleInput = """
R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83
"""

func runPuzzle3(_ optInputFile: URL?) throws {
    let input: String
    if let inputFile = optInputFile {
        input = try String(contentsOf: inputFile, encoding: .utf8)
    }
    else {
        input = sampleInput
    }

    let lines = input
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: "\n")

    let instructionSets = lines.map { (line) in
        line
            .split(separator: ",")
            .map(WireInstruction.init)
    }

    let set1 = coordinates(for: instructionSets[0])
    let set2 = coordinates(for: instructionSets[1])

    let overlaps = set1.intersection(set2)

    let overlapsSortedByManhattanDistance = overlaps.sorted(by: { return $0.manhattanDistance < $1.manhattanDistance })
    print("Nearest overlap:")
    print(overlapsSortedByManhattanDistance.first!)

    let timed1 = timedCoordinates(for: instructionSets[0])
    let timed2 = timedCoordinates(for: instructionSets[1])

    for overlap in overlaps {
        let timed1Score = timed1.first(where: { $0.coordinate == overlap })!.timing
        let timed2Score = timed2.first(where: { $0.coordinate == overlap })!.timing
        print("Overlap: \(overlap) - \(timed1Score) + \(timed2Score) = \(timed1Score+timed2Score)")
    }

}

private func coordinates(for instructions: [WireInstruction]) -> Set<Coordinate> {
    let start = Coordinate(x: 0, y: 0)
    var current = start

    var wireCoordinates: Set<Coordinate> = []
    for instruction in instructions {
        let instructionPoints = instruction.pointsCovered(start: current)
        for x in instructionPoints {
            wireCoordinates.insert(x)
        }
        if let lastPoint = instructionPoints.last {
            current = lastPoint
        }
    }
    return wireCoordinates
}

private func timedCoordinates(for instructions: [WireInstruction]) -> [TimedCoordinate] {
    let start = TimedCoordinate()
    var current = start

    var wireCoordinates: [TimedCoordinate] = []
    for instruction in instructions {
        let instructionPoints = instruction.timedPointsCovered(start: current)
        for x in instructionPoints {
            wireCoordinates.append(x)
        }
        if let lastPoint = instructionPoints.last {
            current = lastPoint
        }
    }
    return wireCoordinates
}

private struct Coordinate: Hashable, CustomStringConvertible {
    var x: Int = 0
    var y: Int = 0

    var description: String {
        return "(\(x), \(y))"
    }

    var manhattanDistance: Int { return abs(x) + abs(y) }

    var left: Coordinate { return Coordinate(x: x-1, y: y) }
    var right: Coordinate { return Coordinate(x: x+1, y: y) }
    var up: Coordinate { return Coordinate(x: x, y: y+1) }
    var down: Coordinate { return Coordinate(x: x, y: y-1) }
}

private struct TimedCoordinate: Hashable {
    var coordinate: Coordinate = .init()
    var timing: Int = 0

    var left: TimedCoordinate { return TimedCoordinate(coordinate: coordinate.left, timing: timing + 1) }
    var right: TimedCoordinate { return TimedCoordinate(coordinate: coordinate.right, timing: timing + 1) }
    var up: TimedCoordinate { return TimedCoordinate(coordinate: coordinate.up, timing: timing + 1) }
    var down: TimedCoordinate { return TimedCoordinate(coordinate: coordinate.down, timing: timing + 1) }
}

private struct WireInstruction {

    enum Direction {
        case up
        case down
        case left
        case right
    }

    var direction: Direction
    var distance: Int

    init<T: StringProtocol>(_ str: T) {
        switch str.first {
        case "R": direction = .right
        case "U": direction = .up
        case "D": direction = .down
        case "L": direction = .left
        default: fatalError()
        }

        guard let distance = Int(str.dropFirst()) else {
            fatalError()
        }
        self.distance = distance
    }

    func pointsCovered(start: Coordinate) -> [Coordinate] {
        var current = start

        var result: [Coordinate] = []
        for _ in 0..<distance {
            switch direction {
            case .up: current = current.up
            case .down: current = current.down
            case .left: current = current.left
            case .right: current = current.right

            }
            result.append(current)
        }

        return result
    }

    func timedPointsCovered(start: TimedCoordinate) -> [TimedCoordinate] {
        var current = start

        var result: [TimedCoordinate] = []
        for _ in 0..<distance {
            switch direction {
            case .up: current = current.up
            case .down: current = current.down
            case .left: current = current.left
            case .right: current = current.right

            }
            result.append(current)
        }

        return result
    }
}


private struct CountedSet<Element: Hashable>: Collection {

    private var dict: [Element: Int] = [:]

    typealias Index = Dictionary<Element,Int>.Index

    var startIndex: Index { return dict.startIndex }
    var endIndex: Index { return dict.endIndex }

    subscript(position: Dictionary<Element, Int>.Index) -> Element {
        _read { yield dict[position].key  }
    }

    func index(after i: Index) -> Index {
        return dict.index(after: i)
    }

    mutating func insert(_ element: Element) {
        dict[element, default: 0] += 1
    }

    mutating func remove(_ element: Element) {
        dict[element, default: 1] -= 1
        if dict[element] == 0 {
            dict[element] = nil
        }
    }

    func count(of element: Element) -> Int {
        return dict[element, default: 0]
    }
}
