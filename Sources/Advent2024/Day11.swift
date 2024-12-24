//
//  Day11.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/12/24.
//

import Foundation
import AdventCore

struct Day11: AdventDay {
    fileprivate var stones: [StoneNode]

    init(data: String) {
        stones = data.split(separator: " ").map{ .value($0.forceInt) }
    }

    func part1() -> Int {
        return run(steps: 25)
    }

    func part2() -> Int {
        return run(steps: 75)
    }

    func run(steps: Int) -> Int {

        var result = 0

        for stone in stones {
            let input = Input(value: stone.value!, steps: steps)
            result += StoneNode.stoneCountForInput(input)
        }
        return result
    }
}


extension Day11 {

    struct Input: Hashable {
        var value: Int
        var steps: Int
    }

    enum StoneNode: Hashable {
        case value(Int)
        indirect case split(StoneNode, StoneNode)

        nonisolated(unsafe)
        static let stoneCountForInput = memoize(_stoneCountForInput)

        static func _stoneCountForInput(_ input: Input) -> Int {
            StoneNode.stoneCount(value: input.value, after: input.steps)
        }

        static func stoneCount(value: Int, after steps: Int) -> Int {
            if steps == 0 {
                return 1
            }

            let node = StoneNode.value(value)
            let newNode = node.step()
            switch newNode {
            case .value(let x):
                let newInput = Input(value: x, steps: steps - 1)
                return stoneCountForInput(newInput)
            case .split(let left, let right):
                let leftInput = Input(value: left.value!, steps: steps - 1)
                let rightInput = Input(value: right.value!, steps: steps - 1)
                let leftCount = stoneCountForInput(leftInput)
                let rightCount = stoneCountForInput(rightInput)
                return leftCount + rightCount
            }
        }


        func step() -> StoneNode {
            switch self {
            case .value(0):
                return .value(1)
            case .value(let x) where x.digitCount.isMultiple(of: 2):
                let digitCount = x.digitCount
                let leftHalf = x / 10.pow(digitCount / 2)
                let rightHalf = x % 10.pow(digitCount / 2)
                return .split(.value(leftHalf), .value(rightHalf))
            case .value(let x):
                return .value(x * 2024)

            case .split(let left, let right):
                return .split(left.step(), right.step())
            }
        }

        var stoneCount: Int {
            switch self {
            case .value:
                return 1
            case .split(let left, let right):
                return left.stoneCount + right.stoneCount
            }
        }

        var value: Int? {
            switch self {
            case .value(let x): return x
            case .split(let left, let right): return nil
            }
        }

        var description: String {
            switch self {
            case .value(let x): "\(x)"
            case .split(let left, let right):
                "\(left.description) \(right.description)"
            }
        }
    }
}
