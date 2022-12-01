//
//  Day1.swift
//
//  Created by BJ Homer on 12/1/20.
//

import Foundation
import Algorithms
import AsyncAlgorithms
import AdventCore



struct Day1 {
    private var elves: [Elf]

    init(input: URL) async {
        self.elves = try! input.allLines
            .map { Int($0) }
            .split(separator: nil)
            .map { Elf(storage: $0.compacted()) }
    }

    func part1() async {
        let highestTotal = elves.map(\.total).max()!
        print(highestTotal)
    }

    func part2() async {
        let answer = elves.map(\.total)
            .sorted()
            .suffix(3)
            .reduce(0, +)
        print(answer)
    }
}

private struct Elf {
    var storage: [Int]

    init(storage: some Sequence<Int>) {
        self.storage = storage.collect()
    }

    var total: Int { storage.reduce(0, +) }
}
