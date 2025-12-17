//
//  Day02.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import AdventCore

struct Day02: AdventDay {
    var ranges: [IDRange] = []
    
    init(data: String) {
        ranges = data
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: ",")
            .map { rangeStr in
                let (low, high) = rangeStr.split(separator: "-").map { Int($0)! }.explode()!
                return IDRange(low: low, high: high)
            }
    }
    
    func part1() -> Int {
        return ranges
            .map { $0.invalidIDs.reduce(0,+) }
            .reduce(0,+)
    }
    
    func part2() -> Int {
        return ranges
            .map { $0.invalidIDsPart2.reduce(0,+) }
            .reduce(0,+)
    }
}

extension Day02 {
    struct IDRange {
        var range: ClosedRange<Int>
        
        init(range: ClosedRange<Int>) {
            self.range = range
        }
        
        init(low: Int, high: Int) {
            self.range = (low...high)
        }
        
        var invalidIDs: [Int] {
            let bottom = (range.lowerBound.nextHigherEvenDigitCountNumber)
            let top = (range.upperBound.nextLowerEvenDigitCountNumber)
            
            if bottom > top { return [] }
            
            var ids: [Int] = []
            var id = bottom
            while id <= top {
                let idStr = String(id)
                let len = idStr.count
                if len.isMultiple(of: 2) == false {
                    id = id.nextHigherEvenDigitCountNumber
                    continue
                }
                let halfLen = len / 2
                if idStr.prefix(halfLen) == idStr.suffix(halfLen) {
                    ids.append(id)
                }
                id += 1
            }
            return ids
        }
        
        var invalidIDsPart2: [Int] {
            var ids: [Int] = []
            
            for id in range {
                let idStr = String(id)
                let len = idStr.count
                if len < 2 { continue }
                
                for i in (1...(len/2)).reversed() {
                    guard len.isMultiple(of: i) else {
                        continue
                    }
                    let chunks = idStr.chunks(ofCount: i)
                    if chunks.allEqual() {
                        ids.append(id)
                        break
                    }
                }
            }
            return ids
        }
    }
}

private extension Int {
    var nextHigherEvenDigitCountNumber: Int {
        let s = String(self)
        if s.count.isMultiple(of: 2) {
            return self
        }
        
        let nextUp = 10.pow(s.count)
        return nextUp
    }
    
    var nextLowerEvenDigitCountNumber: Int {
        let s = String(self)
        if s.count.isMultiple(of: 2) {
            return self
        }
        
        let nextDown = 10.pow(s.count - 1) - 1
        return nextDown
    }
}
