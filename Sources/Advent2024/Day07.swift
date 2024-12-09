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
            .filter { $0.evaluatePart1() }
            .map(\.testValue)
            .reduce(0, +)
    }

    func part2() -> Int {
        return checks
            .filter { $0.evaluatePart2() }
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

            var name: String {
                switch self {
                case .add: return "+"
                case .mul: return "*"
                case .concat: return "||"
                }
            }

            func evaluate(_ x: Int, _ y: Int) -> Int {
                switch self {
                case .add: return x+y
                case .mul: return x*y
                case .concat: return (String(x)+String(y)).int!
                }
            }
            
            static let part1Cases: [Operation] = [.add, .mul]
            static let part2Cases: [Operation] = [.add, .mul, .concat]
        }
        
        init(line: some StringProtocol) {
            let (test, others) = line.split(separator: ":").explode()!
            testValue = test.int!
            numbers = others.split(separator: " ").map { $0.int! }
        }
        
        func evaluatePart1() -> Bool {
            let combos = Operation.part1Cases.combinationsWithReplacement(count: numbers.count - 1)
            return combos.contains(where: { evaluate(operations: $0)} )
        }
        
        func evaluatePart2() -> Bool {
            let combos = Operation.part2Cases.combinationsWithReplacement(count: numbers.count - 1)
            return combos.contains(where: { evaluate(operations: $0)} )
        }
        
        func evaluate(operations: [Operation]) -> Bool {
            var numbers = self.numbers[...]
            var result = numbers.popFirst()!

            print("evaluating \(operations.map(\.name))")

            for (num, op) in zip(numbers, operations) {
                result = op.evaluate(result, num)
                if result > testValue {
                    return false
                }
            }
            return result == testValue
        }
    }
}
