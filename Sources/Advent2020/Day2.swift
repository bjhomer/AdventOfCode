//
//  Day2.swift
//  AdventOfCode2020
//
//  Created by BJ Homer on 12/2/20.
//

import Foundation


func day2(input: Data) {
    let lines = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap { PasswordLine(String($0)) }


    print("-------")
    print("Part 1:")
    let validLinesPart1 = lines.filter( {$0.checkValidityPart1() } )
    print(validLinesPart1.count)

    print("")
    print("-------")
    print("Part 2:")
    let validLinesPart2 = lines.filter( {$0.checkValidityPart2() } )
    print(validLinesPart2.count)
}

struct PasswordRequirementPart1 {
    var expectedCharacter: Character
    var expectedCountRange: ClosedRange<Int>

    func isValid(_ password: String) -> Bool {
        let letterCount = password
            .filter { $0 == expectedCharacter }
            .count
        return expectedCountRange.contains(letterCount)
    }
}

struct PasswordRequirementPart2 {
    var expectedCharacter: Character
    var positions: [Int]

    func isValid(_ password: String) -> Bool {
        let characters = positions
            .map { password.dropFirst($0-1).first! }

        let matchingCount = characters
            .filter { $0 == expectedCharacter }
            .count

        return matchingCount == 1
    }
}

struct PasswordLine {
    var range: ClosedRange<Int>
    var character: Character
    var password: String

    init?(_ string: String) {
        // 1-3 a: abcde
        let segments = string.split(separator: " ")
        guard segments.count == 3 else { return nil }

        let lengthSegment = segments[0]
        let lengthStrings = lengthSegment.split(separator: "-")
        let min = Int(lengthStrings[0])!
        let max = Int(lengthStrings[1])!

        let expectedCharacter = segments[1].first!
        self.password = String(segments[2])
        self.range = min...max
        self.character = expectedCharacter
    }

    func checkValidityPart1() -> Bool {
        let requirement = PasswordRequirementPart1(
            expectedCharacter: character,
            expectedCountRange: range)
        return requirement.isValid(password)
    }

    func checkValidityPart2() -> Bool {
        let requirement = PasswordRequirementPart2(
            expectedCharacter: character,
            positions: [range.lowerBound, range.upperBound])
        return requirement.isValid(password)
    }
}


