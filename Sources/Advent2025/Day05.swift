//
//  Day05.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import AdventCore

struct Day05: AdventDay {
    var validRanges: [Range<Int>]
    var ids: [Int]

    init(data: String) {
        let (p1, p2) = data.split(separator: "\n\n").explode()!
        
        validRanges = p1.lines
            .map { line in
                let (lowS, high) = line.split(separator: "-").explode()!
                return Int(lowS)! ..< Int(high)!+1
            }
        
        ids = p2.lines.compactMap { Int($0) }
    }
    
    func part1() -> Int {
        var set = RangeSet<Int>()
        for range in validRanges {
            set.insert(contentsOf: range)
        }
        
        return ids.count(where: { set.contains($0) })
    }
    
    func part2() -> Int {
        var set = RangeSet<Int>()
        for range in validRanges {
            set.insert(contentsOf: range)
        }
        
        return set.ranges.map(\.count).reduce(0, +)
    }
}
