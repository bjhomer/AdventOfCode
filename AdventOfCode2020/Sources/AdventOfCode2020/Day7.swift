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
        .compactMap(Rule.init)

    let ruleDict: [String: Rule] = rules.keyed(by: \.bagType)
    let invertedDict = ruleDict.invertedRules()

    var allContainers: Set<String> = []
    var newProducts: Set<String> = ["shiny gold"]

    while newProducts.isEmpty == false {
        let producedThisRound = newProducts.flatMap { Set(invertedDict[$0] ?? []) }
        allContainers.formUnion(producedThisRound)

        newProducts = Set(producedThisRound)
    }
    print("Part 1:", allContainers.count)

    let rule = ruleDict["shiny gold"]!

    let insideMyBag = rule.contents(using: ruleDict)
    print("Part 2:", insideMyBag.count)


}

extension Dictionary where Key == String, Value == Rule {
    func invertedRules() -> [String: [String]] {
        var result: [String: [String]] = [:]
        for (key, rule) in self {
            let producedTypes = rule.products.map(\.type)

            for producedType in producedTypes {
                result[producedType, default: []].append(key)
            }
        }
        return result
    }
}


struct Rule {

    var bagType: String
    var products: [ProducedBag]

    init(bagType: String, produces: [ProducedBag]) {
        self.bagType = bagType
        self.products = produces
    }

    //light red bags contain 1 bright white bag, 2 muted yellow bags.
    init?<Str>(_ line: Str) where Str: StringProtocol {

        let regex: Regex = #"(.+) bags contain (.+)\."#
        guard let match = regex.match(line) else { return nil }

        self.bagType = match[1]

        let containedString = match[2]
        switch containedString {
        case "no other bags":
            products = []

        case let things:
            products = things
                .split(separator: ", ")
                .compactMap { ProducedBag($0) }
        }
    }

    func contents(using rules: [String: Rule]) -> [String] {
        let immediateBags = self.products
            .reduce(into: [] as [String]) { (array, rule) in
                array.append(contentsOf: rule.products)
        }

        return immediateBags +
            immediateBags.flatMap { rules[$0]!.contents(using: rules) }
    }

}

struct ProducedBag {
    var count: Int
    var type: String

    var products: [String] {
        Array(repeating: type, count: count)
    }

    init(type: String, count: Int = 1) {
        self.type = type
        self.count = count
    }

    init?<Str>(_ line: Str) where Str: StringProtocol {
        let regex: Regex = #"(\d+) (.+) bags?"#

        guard let match = regex.match(line) else { return nil }

        self.count = Int(match[1])!
        self.type = match[2]
    }
}

