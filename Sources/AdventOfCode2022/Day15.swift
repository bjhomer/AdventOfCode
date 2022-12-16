//
//  File.swift
//  
//
//  Created by BJ Homer on 12/14/22.
//

import Foundation
import AdventCore
import SE0270_RangeSet

struct Day15: Day {

    private var readings: [SensorReading]
    private var isSample: Bool
    init(input: URL) async throws {
        readings = try input.allLines.compactMap { SensorReading(line: $0) }
        isSample = input.lastPathComponent.contains("Sample")
    }

    func part1() async {
        let rowToRead = (isSample ? 10 : 2000000)

        var rangeSet = RangeSet<Int>()

        for reading in readings {
            if let eliminatedRange = reading.eliminatedRange(row: rowToRead) {
                rangeSet.insert(contentsOf: Range(eliminatedRange))

                if rowToRead == reading.nearestBeacon.r {
                    rangeSet.remove(reading.nearestBeacon.c)
                }
            }
        }
        print(rangeSet.count)
    }

    func part2() async {
        let scale = isSample ? 20 : 4000000

        let start = Date()
        for r in 0...scale {
            var rangeSet = RangeSet([Range(0...scale)])

            for reading in readings {
                if let eliminatedRange = reading.eliminatedRange(row: r) {
                    rangeSet.remove(contentsOf: Range(eliminatedRange))
                }
            }
            if rangeSet.count == 1 {
                let c = rangeSet.values.first!
                print(c, r)
                print(c * scale + r)
                break
            }
        }
        print(Date().timeIntervalSince(start))
        print("done")

    }
}


private struct SensorReading {
    var location: GridPoint
    var nearestBeacon: GridPoint
    var distanceToBeacon: Int

    init?(line: some StringProtocol) {
        let regex = #/Sensor at x=(?<lx>-?\d+), y=(?<ly>-?\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/#
        guard let match = String(line).wholeMatch(of: regex) else { return nil }

        location = GridPoint(x: Int(match.lx)!, y: Int(match.ly)!)
        nearestBeacon = GridPoint(x: Int(match.bx)!, y: Int(match.by)!)
        distanceToBeacon = location.manhattanDistance(to: nearestBeacon)
    }


    func eliminatesBeacon(at point: GridPoint) -> Bool {
        return point.manhattanDistance(to: location) <= distanceToBeacon
    }

    func eliminatedRange(row: Int) -> ClosedRange<Int>? {
        let columnDelta = distanceToBeacon - abs(row - location.r)
        if columnDelta < 0 { return nil }
        let result = (location.c - columnDelta)...(location.c + columnDelta)
        return result
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

private extension RangeSet<Int> {
    mutating func remove(_ x: Int) {
        let range = x..<(x+1)
        self.remove(contentsOf: range)
    }

    var count: Int {
        return self.ranges.map(\.count).reduce(0, +)
    }

    var values: [Int] {
        return self.ranges.flatMap({$0})
    }
}
