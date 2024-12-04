//
//  Day03.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/24.
//

import Foundation
import AdventCore
import RegexBuilder

struct Day03: AdventDay {
    var input: String

    init(data: String) {
        input = data
    }

    func part1() -> Int {
        let regex = /mul\((\d{1,3}),(\d{1,3})\)/
        let matches = input.matches(of: regex)

        return matches.map { Int($0.output.1)! * Int($0.output.2)! }
            .reduce(0, +)
    }

    func part2() -> Int {

        let regex = Regex {
            ChoiceOf {
                /(mul)\((\d{1,3}),(\d{1,3})\)/
                /(do)\(\)/
                /(don't)\(\)/
            }
        }

        var mul_enabled = true
        var result = 0

        for match in input.matches(of: regex) {
            switch match.output.1 ?? match.output.4 ?? match.output.5 {
            case "mul":
                guard mul_enabled else { continue }
                result += Int(match.output.2!)! * Int(match.output.3!)!
            case "do":
                mul_enabled = true
            case "don't":
                mul_enabled = false
            default:
                continue
            }
        }
        return result
    }
}
