//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore

func day7(input: Data) {
    let rules = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .map(Rule.init)

    let ruleDict = rules.keyed(by: <#T##(Rule?) -> Hashable#>)


}


struct Rule {
    var term: String
    var produces: [ProducedBag]


    //light red bags contain 1 bright white bag, 2 muted yellow bags.
    init?<Str>(_ line: Str) where Str: StringProtocol {

        let regex: Regex = #"(.+) bags contain (.+)\."#
        guard let match = regex.match(line) else { return nil }

        self.term = match[1]

        let containedString = match[2]
        switch containedString {
        case "no other bags":
            produces = []

        case let things:
            produces = things
                .split(separator: ", ")
                .compactMap { ProducedBag($0) }
        }
    }
}

struct ProducedBag {
    var count: Int
    var type: String

    init?<Str>(_ line: Str) where Str: StringProtocol {
        let regex: Regex = #"(\d+) \(.+) bags?"#

        guard let match = regex.match(line) else { return nil }

        self.count = Int(match[1])!
        self.type = match[2]
    }
}

