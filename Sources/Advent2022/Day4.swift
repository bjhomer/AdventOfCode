//
//  Day4.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import RegexBuilder

struct Day4: Day {

    private var pairs: [Pair]

    init(input: URL) async throws {
        let lines = try input.allLines

        self.pairs = lines.compactMap { line -> Pair? in
            guard let (_, aStr, bStr, cStr, dStr) = line.wholeMatch(of: #/(\d+)-(\d+),(\d+)-(\d+)/# )?.output,
                  let (a, b, c, d) = [aStr, bStr, cStr, dStr].map({ Int($0)! }).explode()
            else { return nil }

            return Pair(range1: a...b, range2: c...d)
        }
    }

    func part1() async {
        let result = pairs.filter(\.fullyOverlaps).count
        print(result)
    }

    func part2() async {
        let result = pairs.filter(\.overlaps).count
        print(result)
    }
}


private struct Pair {
    var range1: ClosedRange<Int>
    var range2: ClosedRange<Int>

    var fullyOverlaps: Bool {
        return range1.contains(range2) || range2.contains(range1)
    }

    var overlaps: Bool {
        return range1.overlaps(range2)
    }
}


private extension ClosedRange {

    func contains(_ other: Self) -> Bool {
        return lowerBound <= other.lowerBound && upperBound >= other.upperBound
    }

}
