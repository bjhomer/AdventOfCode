//
//  Day06.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/2025.
//

import Foundation
import Algorithms
import AdventCore

struct Day06: AdventDay {
    var rawInput: String
    
    init(data: String) {
        rawInput = data
    }
    
    func part1() -> Int {
        let lines = rawInput.lines
        
        var problems: [Problem]
        let numberLines = lines.dropLast().map { line in
            line.split(separator: " ").map { Int($0)! }
        }
        
        let operations = lines.last!.split(separator: " ")
            .compactMap { Problem.Operation($0) }
        
        problems = operations.indices
            .map { idx in
                let numbers = numberLines.map { $0[idx] }
                return Problem(numbers: numbers, operation: operations[idx])
            }

        return problems.reduce(0) { $0 + $1.result }
    }
    
    func part2() -> Int {
        let lines = rawInput.lines
        let zippedLines = zipSequences(lines.dropLast())
        
        let operations = lines.last!.split(separator: " ")
            .compactMap { Problem.Operation($0) }
        
        
        let problemDescriptions = zippedLines.split(whereSeparator: { $0.allEqual(" ") })
        
        var problems: [Problem] = []
        for (columnSet, operation) in zip(problemDescriptions, operations) {
            let columns = columnSet.map { column in
                Int(String(column.trimming(while: \.isWhitespace)))!
            }
            let problem = Problem(numbers: columns, operation: operation)
            problems.append(problem)
        }
        
        let result = problems.reduce(0) { $0 + $1.result }
        return result
    }
}

extension Day06 {
    struct Problem {
        enum Operation {
            case add
            case multiply
            init?(_ str: Substring) {
                switch str {
                case "+": self = .add
                case "*": self = .multiply
                default: return nil
                }
            }
            
            
            var string: String {
                switch self {
                case .add: "+"
                case .multiply: "*"
                }
            }
        }
        
        var numbers: [Int]
        var operation: Operation
        
        var result: Int {
            switch operation {
            case .add: return numbers.reduce(0, +)
            case .multiply: return numbers.reduce(1, *)
            }
        }
        
        var description: String {
            numbers.map(\.description).joined(separator: " \(operation.string) ")
        }
    }
}
