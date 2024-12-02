//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore
import Algorithms


func day12(input: String) {
    let json = try! JSONValue(with: Data(input.utf8))
    let part1 = json.allInts.reduce(0, +)
    print("Part 1: \(part1)")

    let part2 = json.allIntsWithoutReds.reduce(0, +)
    print("Part 2: \(part2)")
}

private extension JSONValue {

    var allInts: [Int] {
        switch self {
        case .array(let a): return Array(a.flatMap(\.allInts))
        case .object(let obj): return Array(obj.values.flatMap(\.allInts))
        case .double: return []
        case .int(let i): return [i]
        case .null: return []
        case .string: return []
        case .bool: return []
        }
    }

    var allIntsWithoutReds: [Int] {
        switch self {
        case .array(let a): return Array(a.flatMap(\.allIntsWithoutReds))
        case .object(let obj):
            if obj.values.contains("red") { return [] }
            return Array(obj.values.flatMap(\.allIntsWithoutReds))
        case .double: return []
        case .int(let i): return [i]
        case .null: return []
        case .string: return []
        case .bool: return []
        }
    }
}
