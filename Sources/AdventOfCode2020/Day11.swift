//
//  Day9.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day11(input: Data) {
    let string = String(decoding: input, as: UTF8.self)

    var grid = Grid(string)

    while true {
        print(".", terminator: "")
        let nextStep = grid.step()
        if nextStep == grid { break }
        grid = nextStep
    }

    let part1 = grid.occupiedSeats
    print("\nPart 1:", part1)

    var grid2 = Grid(string)
    while true {
        print(".", terminator: "")
        let nextStep = grid2.step2()
        if nextStep == grid2 { break }
        grid2 = nextStep
    }

    let part2 = grid2.occupiedSeats
    print("\nPart 2:", part2)

}

private enum Seat: Character {
    case floor = "."
    case emptySeat = "L"
    case occupiedSeat = "#"

    init(_ char: Character) {
        self.init(rawValue: char)!
    }
}

private struct Point: Equatable {
    var row: Int
    var column: Int

    var surroundingPoints: [Point] {
        var points: [Point] = []
        for r in [-1, 0, 1] {
            for c in [-1, 0, 1] {
                if r == 0 && c == 0 { continue }
                points.append(Point(row: row+r, column: column+c))
            }
        }
        return points
    }

    func offset(by other: Point) -> Point {
        return Point(row: row + other.row, column: column + other.column)
    }
}

private struct Grid: Equatable {
    var seats: [[Seat]]

    var occupiedSeats: Int {
        var count = 0
        for (r, c) in product(0..<height, 0..<width) {
            if self[r, c] == .occupiedSeat { count += 1}
        }
        return count
    }

    var width: Int { return seats[0].count }
    var height: Int { return seats.count }

    init(_ string: String) {
        let lines = string.split(separator: "\n")
        let rows = lines.map { (line) in line.map(Seat.init) }

        self.seats = rows
    }

    subscript(_ row: Int, _ column: Int) -> Seat? {
        get {
            guard (0..<width).contains(column),
                  (0..<height).contains(row)
            else { return nil }

            return seats[row][column]
        }
        set {
            guard let value = newValue,
                  (0..<width).contains(column),
                  (0..<height).contains(row)
            else { return }

            seats[row][column] = value
        }
    }

    subscript(_ point: Point) -> Seat? {
        get { return self[point.row, point.column] }
        set { self[point.row, point.column] = newValue }
    }

    func occupiedSeatCount(around point: Point) -> Int {
        return point.surroundingPoints.filter { self[$0] == .occupiedSeat }.count
    }

    func step() -> Grid {
        var copy = self

        for (r, c) in product(0..<height, 0..<width) {
            let point = Point(row: r, column: c)
            let currentSeat = self[point]

            if currentSeat == .floor { continue }

            switch (currentSeat, self.occupiedSeatCount(around: point)) {
            case (.emptySeat, 0):
                copy[point] = .occupiedSeat
            case (.occupiedSeat, 4...):
                copy[point] = .emptySeat
            default: break
            }
        }
        return copy
    }

    func nonFloorPoint(from point: Point, along vector: Point) -> Point? {
        var current = point
        while true {
            let next = current.offset(by: vector)
            switch self[next] {
            case .emptySeat, .occupiedSeat: return next
            case .floor: break
            case nil: return nil
            }
            current = next
        }
    }

    static let vectors: [Point] = {
        var result: [Point] = []
        for r in [-1,0,1] {
            for c in [-1,0,1] {
                if r == 0 && c == 0 { continue }
                result.append(Point(row:r, column: c))
            }
        }
        return result
    }()


    func visibleOccupiedCount(around point: Point) -> Int {
        var count = 0

        for vector in Grid.vectors {
            guard let visiblePoint = self.nonFloorPoint(from: point, along: vector) else { continue }
            if self[visiblePoint] == .occupiedSeat {
                count += 1
            }
        }
        return count

    }

    func step2() -> Grid {
        var copy = self

        for (r, c) in product(0..<height, 0..<width) {
            let point = Point(row: r, column: c)
            let currentSeat = self[point]

            if currentSeat == .floor { continue }

            switch (currentSeat, self.visibleOccupiedCount(around: point)) {
            case (.emptySeat, 0):
                copy[point] = .occupiedSeat
            case (.occupiedSeat, 5...):
                copy[point] = .emptySeat
            default: break
            }
        }
        return copy
    }

    func print() {

        for line in seats {
            let chars = line.map { $0.rawValue }
            let string = String(chars)
            Swift.print(string)
        }
    }

}
