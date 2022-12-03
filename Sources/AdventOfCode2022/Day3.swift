//
//  Day3.swift
//  
//
//  Created by BJ Homer on 12/2/22.
//

import Foundation
import Algorithms

struct Day3: Day {
    private var sacks: [Sack]

    init(input: URL) async throws {
        let lines = try input.allLines
        sacks = lines.compactMap { Sack(line: $0) }
    }

    func part1() async {
        let value = sacks.map(\.splitItem.value).reduce(0, +)
        print(value)
    }

    func part2() async {

        let groups = sacks.chunks(ofCount: 3)

        let badges = groups.map { group in
            let sets = group.map { Set($0.allItems) }
            let badge = sets.reduce { $0.intersection($1) }!.first!
            return badge
        }

        let answer = badges.map(\.value).reduce(0,+)
        print(answer)
    }


}


private struct Sack {
    var part1: [Item]
    var part2: [Item]

    var allItems: [Item] { part1+part2 }

    init?(line: some StringProtocol) {
        let chars = Array(line)
        let length = chars.count
        if length == 0 { return nil }
        part1 = chars.prefix(length/2).map { Item.init(name: $0) }
        part2 = chars.suffix(length/2).map { Item.init(name: $0) }
    }

    var splitItem: Item {
        Set(part1).intersection(part2).first!
    }
}

private struct Item: Hashable {
    var name: Character

    var value: Int {
        if name.isUppercase {
            return Int(name.asciiValue! - ("A" as Character).asciiValue! + 1) + 26
        }
        else {
            return Int(name.asciiValue! - ("a" as Character).asciiValue! + 1)
        }
    }
}
