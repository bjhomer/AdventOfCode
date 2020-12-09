//
//  Day3.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import Algorithms


func day3(input text: String) {

    let points = text.scan(Point.zero) { $0.move(by: $1) }

    let part1 = Set(points).count
    print("Part 1:", part1)

    let part2Points = text
        .deinterlaced(stride: 2)
        .map { $0.scan(Point.zero) { $0.move(by: $1) } }
        .joined()


    let part2 = Set(part2Points).count
    print("Part 2:", part2)
}

private struct Point: Hashable {
    var x: Int
    var y: Int

    static var zero: Point { Point(x: 0, y: 0) }

    func move(by direction: Character) -> Point {
        switch direction {
        case "^": return Point(x: x, y: y+1)
        case "v": return Point(x: x, y: y-1)
        case ">": return Point(x: x+1, y: y)
        case "<": return Point(x: x-1, y: y)
        default: return self
        }
    }
}

extension Point: CustomStringConvertible {
    var description: String {
        return "(\(x), \(y))"
    }
}


private extension Sequence {
    /// Returns an array containing the results of
    ///
    ///   p.reduce(initial, nextPartialResult)
    ///
    /// for each prefix `p` of `self`, in order from shortest to
    /// longest. For example:
    ///
    ///     (1..<6).scan(0, +) // [0, 1, 3, 6, 10, 15]
    ///
    /// - Complexity: O(n)
    func scan<Result>(
        _ initial: Result,
        _ nextPartialResult: (Result, Element) -> Result
    ) -> [Result] {
        var result = [initial]
        for x in self {
            result.append(nextPartialResult(result.last!, x))
        }
        return result
    }

    func deinterlaced(stride: Int) -> [[Element]] {
        var resultArrays: [[Element]] = Array(repeating: [], count: stride)

        for (n, element) in self.enumerated() {
            resultArrays[n % stride].append(element)
        }
        return resultArrays
    }
}


