//
//  File.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Foundation
import AdventCore

struct Day01: AdventDay {
    var list1: [Int]
    var list2: [Int]
    
    init(data: String) {
        list1 = []
        list2 = []
        for line in data.lines {
            let (a, b) = line
                .split(separator: " ")
                .map({ Int($0)! })
                .explode()!
            list1.append(a)
            list2.append(b)
        }
    }
    
    func part1() -> Int {
        let pairs = zip(list1.sorted(), list2.sorted())
        return pairs.map { abs($0.0 - $0.1)}.reduce(0, +)
    }
    
    func part2() -> Int {
        let counts = NSCountedSet(array: list2)
        let result = list1.map { counts.count(for: $0) * $0 }.reduce(0, +)
        return result
    }
}
