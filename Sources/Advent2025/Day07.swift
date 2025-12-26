//
//  Day07.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import Algorithms
import AdventCore

struct Day07: AdventDay {
    var input: String
    
    init(data: String) {
        input = data
    }
    
    func part1() -> Int {
        var activeBeams: RangeSet<Int> = .init()
        var splitCount = 0
        
        let (firstLines, lines) = input.lines.divided(at: 1)
        let firstLine = Array(firstLines[0])
        
        let startIndex: Int = Array(firstLine).firstIndex(of: "S")!
        activeBeams.insert(startIndex, within: firstLine)
        
        for line in lines {
            let splitterIndices = Array(line).indices(of: "^")
            let splitBeams = activeBeams.intersection(splitterIndices)
            
            splitCount += splitBeams.ranges.reduce(0, {$0 + $1.count})
            
            for beam in splitBeams.values {
                activeBeams.remove(beam, within: firstLine)
                activeBeams.insert(beam - 1, within: firstLine)
                activeBeams.insert(beam + 1, within: firstLine)
            }
        }
        return splitCount
    }
    
    func part2() -> Int {
        var activeBeams: [Int: Int] = [:]
        
        var activeTimelines = 1
        
        let (firstLines, lines) = input.lines.divided(at: 1)
        let firstLine = Array(firstLines[0])
        
        let startIndex: Int = Array(firstLine).firstIndex(of: "S")!
        activeBeams[startIndex] = 1
        
        for line in lines {
            let splitterIndices = Array(line).indices(of: "^")
            for idx in splitterIndices.values {
                let existingCount = activeBeams[idx, default: 0]
                activeBeams[idx] = 0
                activeBeams[idx - 1, default: 0] += existingCount
                activeBeams[idx + 1, default: 0] += existingCount
                
                // Each existing beam that hits this is split
                activeTimelines += existingCount
            }
        }
        return activeTimelines
    }
}
