//
//  Day03.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import AdventCore

struct Day03: AdventDay {
    var batteries: [Battery]
    
    init(data: String) {
        batteries = data.lines.compactMap { Battery(line: $0) }
    }
    
    func part1() -> Int {
        return batteries
            .map { $0.maxValue() }
            .reduce(0, +)
    }
    
    func part2() -> Int {
        return batteries
            .map { $0.maxValuePart2() }
            .reduce(0, +)
    }
}

extension Day03 {
    struct Battery {
        var numbers: [Int]
        
        init?(line: some StringProtocol) {
            numbers = line.compactMap { $0.int }
            if numbers.isEmpty { return nil }
        }
        
        func maxValue() -> Int {
            let (digit1Index, digit1) = numbers
                .dropLast()
                .indexed()
                .max(by: { $0.element < $1.element })!
            
            let digit2 = numbers[(digit1Index+1)...].max()!
            return (digit1 * 10) + digit2
        }
        
        func maxValuePart2() -> Int {
            return maxValue(intermediateValue: 0, startIndex: 0, remainingDigits: 12)
        }
        
        func maxValue(intermediateValue: Int, startIndex: Array.Index, remainingDigits: Int) -> Int {
         
            if remainingDigits <= 0 {
                return intermediateValue
            }
            let (nextDigitIndex, nextDigit) =
            numbers[startIndex...]
                .dropLast(remainingDigits-1)
                .indexed()
                .max(by: { $0.element < $1.element })!
            
            let x = (intermediateValue * 10) + nextDigit
            
            return maxValue(intermediateValue: x,
                            startIndex: nextDigitIndex+1,
                            remainingDigits: remainingDigits - 1)
        }
    }
}
