//
//  File.swift
//  
//
//  Created by BJ Homer on 12/14/22.
//

import Foundation
import AdventCore

struct Day15: Day {

    private var readings: [SensorReading]
    private var isSample: Bool
    init(input: URL) async throws {
        readings = try input.allLines.compactMap { SensorReading(line: $0) }
        isSample = input.lastPathComponent.contains("Sample")
    }

    func part1() async {
        let minX = readings.map { $0.location.x - $0.distanceToBeacon }.min()!
        let maxX = readings.map { $0.location.x + $0.distanceToBeacon }.max()!
        let minY = readings.map { $0.location.y - $0.distanceToBeacon }.min()!
        let maxY = readings.map { $0.location.y + $0.distanceToBeacon }.max()!

        let topLeft = GridPoint(x: minX, y: minY)
        let bottomRight = GridPoint(x: maxX, y: maxY)

        var grid = Grid<Character>(topLeft: topLeft, bottomRight: bottomRight, defaultValue: ".")

        for reading in readings {
            grid[reading.location] = "S"
            grid[reading.nearestBeacon] = "B"
            for point in grid.pointsWithinManahattanDistance(reading.distanceToBeacon, of: reading.location) {
                if grid[point] == "." { grid[point] = "#" }
            }
        }

        let result = grid[row: isSample ? 10 : 20_000].lazy
            .filter { $0 == "#" || $0 == "S" }
            .count

//        print(grid)
//        print("")
        print(result)
    }

    func part2() async {

    }
}


private struct SensorReading {
    var location: GridPoint
    var nearestBeacon: GridPoint

    init?(line: some StringProtocol) {
        let regex = #/Sensor at x=(?<lx>-?\d+), y=(?<ly>-?\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/#
        guard let match = String(line).wholeMatch(of: regex) else { return nil }

        location = GridPoint(x: Int(match.lx)!, y: Int(match.ly)!)
        nearestBeacon = GridPoint(x: Int(match.bx)!, y: Int(match.by)!)
    }

    var distanceToBeacon: Int {
        location.manhattanDistance(to: nearestBeacon)
    }
}

private extension GridPoint {
    func manhattanDistance(to other: GridPoint) -> Int {
        return abs(x - other.x) + abs(y - other.y)
    }
}

private extension Grid {
    func pointsWithinManahattanDistance(_ distance: Int, of point: GridPoint) -> [GridPoint] {
        var points: [GridPoint] = []

        let top = point.offset(r: -distance, c: 0)
        let bottom = point.offset(r: distance, c: 0)
        for row in (top.r)...(bottom.r) {
            let columnRange = distance - abs(row - point.r)
            for col in (point.c - columnRange)...(point.c + columnRange) {
                points.append(GridPoint(r: row, c: col))
            }
        }
        return points
    }
}
