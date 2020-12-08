//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore

func day6(input: Data) {

    let groups = String(decoding: input, as: UTF8.self)
        .split(separator: "\n\n")
        .map { $0.split(separator: "\n") }
        .map(Group.init)


    let part1 = groups.map(\.uniqueAnswers.count).reduce(0, +)
    print("Part 1:", part1)

    let part2 = groups.map(\.commonAnswers.count).reduce(0, +
    )
    print("Part 2:", part2)

}

private struct Group {
    var lines: [String]
    init<C>(lines: C) where C: Collection, C.Element: StringProtocol {
        self.lines = lines.filter({ $0.isEmpty == false}).map({ String($0) })
    }

    var uniqueAnswers: Set<Character> {
        Set(lines.joined())
    }

    var commonAnswers: Set<Character> {
        let sets = lines.map(Set.init)
        let commonAnswers = sets.reduce { return $0.intersection($1) }!
        return commonAnswers
    }
}

