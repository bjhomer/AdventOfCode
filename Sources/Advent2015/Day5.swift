//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import AdventCore

func day5(input: String) {
    let lines = input.split(separator: "\n")


    let part1 = lines.map(\.isNicePart1)
        .filter { $0 == true }
        .count

    print("Part 1:", part1)

    let part2 = lines.map(\.isNicePart2)
        .filter { $0 == true }
        .count

    print("Part 2:", part2)

    assert("qjhvhtzxzqqjkmpb".isNicePart2)
    assert("xxyxx".isNicePart2)
    assert("uurcxstgmygtbstg".isNicePart2 == false)
    assert("ieodomkazucvgmuy".isNicePart2 == false)

}

private extension StringProtocol {
    var isNicePart1: Bool {
        let vowels = Set("aeiou")
        let vowelCount = self.filter { vowels.contains($0) }.count

        let hasDouble = self
            .chunked(by: { $0 == $1 })
            .filter { $0.count > 1 }
            .count > 0

        let naughtyStrings = ["ab", "cd", "pq", "xy"]
        let hasNaughty = naughtyStrings.contains(where: { self.range(of: $0) != nil })

        return vowelCount >= 3 && hasDouble && !(hasNaughty)
    }

    var isNicePart2: Bool {
        let repeatedSubstringRegex: ACRegex = #"(..).*(\1)"#
        let hasRepeatedSet = repeatedSubstringRegex.match(self) != nil

        let abaRegex: ACRegex = #"(.).(\1)"#
        let hasABA = abaRegex.match(self) != nil

        return hasRepeatedSet && hasABA
    }
}
