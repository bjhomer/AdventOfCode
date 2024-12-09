//
//  Day07.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/3/24.
//

import Foundation
import AdventCore
import Algorithms

struct Day07: AdventDay {

    private let checks: [CalibrationCheck]

    init(data: String) {
        checks = data.lines.map(CalibrationCheck.init)
    }

    func part1() -> Int {
        return checks
            .filter { $0.evaluate(operations: [.mul, .add]) }
            .map(\.testValue)
            .reduce(0, +)
    }

    func part2() -> Int {
        return checks
            .filter { $0.evaluate(operations: [.concat, .mul, .add]) }
            .map(\.testValue)
            .reduce(0, +)
    }
}

extension Day07 {
    struct CalibrationCheck {
        var testValue: Int
        var numbers: [Int]
        
        enum Operation: CaseIterable {
            case add
            case mul
            case concat

            func evaluate(_ x: Int, _ y: Int) -> Int {
                switch self {
                case .add: return x+y
                case .mul: return x*y
                case .concat: return x * 10.pow(y.digitCount) + y
                }
            }

        }
        
        init(line: some StringProtocol) {
            let (test, others) = line.split(separator: ":").explode()!
            testValue = test.int!
            numbers = others.split(separator: " ").map { $0.int! }
        }
        
        func evaluate(operations: [Operation]) -> Bool {
            var numbers = self.numbers[...]
            let next = numbers.popFirst()!
            let rest = numbers

            return evaluateBounded(next, remainingNums: rest, operations: operations)
        }

        func evaluateBounded(_ resultSoFar: Int, remainingNums: some Collection<Int>, operations: [Operation]) -> Bool
        {
            var remainingNums = remainingNums[...]
            if remainingNums.isEmpty {
                return resultSoFar == testValue
            }
            if resultSoFar > testValue {
                return false
            }

            let next = remainingNums.popFirst()!

            for op in operations {
                if evaluateBounded(op.evaluate(resultSoFar, next), remainingNums: remainingNums, operations: operations) {
                    return true
                }
            }
            return false
        }
    }
}
