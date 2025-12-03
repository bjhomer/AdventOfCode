//
//  File.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Foundation
import AdventCore

struct Day01: AdventDay {
    var inputs: [Int]
    
    init(data: String) {
        inputs = data
            .split(separator: "\n")
            .compactMap {
                switch $0.first {
                case "L": return -Int($0.dropFirst())!
                case "R": return Int($0.dropFirst())!
                default: fatalError()
                }
            }
    }
    
    func part1() -> Int {
        var start = 50
        var zeroCount: Int = 0
        
        for input in inputs {
            start = (start + input).positiveMod(100)
            if start == 0 {
                zeroCount += 1
            }
        }
        return zeroCount
    }
    
    func part2() -> Int {
        var value = 50
        var zeroCount: Int = 0
        
        for input in inputs {
            let originalValue = value
            value = (value + input)
            
            let zeroDelta: Int
            if value >= 100 {
                zeroDelta = (value / 100)
                value = value.positiveMod(100)
            }
            else if value < 0 {
                zeroDelta = -(value / 100) + (originalValue == 0 ? 0 : 1)
                value = value.positiveMod(100)
            }
            else if value == 0 {
                zeroDelta = 1
            }
            else {
                zeroDelta = 0
            }
            zeroCount += zeroDelta
            debug("\(originalValue) + \(input) =\t\(originalValue + input)\t-> \(value)\t\(zeroDelta) zero(s)")
        }
        return zeroCount
    }
}
