//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day7(input: Data) {
    let bagTypes = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")
        .compactMap(BagType.init)

    let catalog = LuggageCatalog(bagTypes: bagTypes)
    let shinyGold = catalog.colorsToBagTypes["shiny gold"]!
    let part1 = shinyGold.allPossibleContainers(using: catalog).count
    print("Part 1:", part1)


    let insideMyBag = shinyGold.contents(using: catalog)
    print("Part 2:", insideMyBag.count)


}

extension Dictionary  {
    init<T>(groupedPairs: [(Key, T)]) where Value == [T] {
        self = [:]
        for pair in groupedPairs {
            self[pair.0, default: []].append(pair.1)
        }
    }
}


class LuggageCatalog {
    var bagTypes: [BagType]

    init(bagTypes: [BagType]) {
        self.bagTypes = bagTypes
    }

    subscript(_ color: String) -> BagType? {
        return colorsToBagTypes[color]
    }

    lazy var colorsToBagTypes: [String: BagType] = bagTypes.keyed(by: \.color)

    lazy var colorsToContainingColors: [String: [String]] = {
        let innerOuterPairs = colorsToContainedColors.flatMap { (k, v) in product(v, [k]) }
        return Dictionary(groupedPairs: innerOuterPairs)
    }()

    lazy var colorsToContainedColors: [String: [String]] = {
        colorsToBagTypes.mapValues({ $0.contents.map(\.color) })
    }()
}

struct BagType: Hashable {

    var color: String
    var contents: [ContainedBag]

    init(bagType: String, produces: [ContainedBag]) {
        self.color = bagType
        self.contents = produces
    }

    //light red bags contain 1 bright white bag, 2 muted yellow bags.
    init?<Str>(_ line: Str) where Str: StringProtocol {

        let regex: Regex = #"(.+) bags contain (.+)\."#
        guard let match = regex.match(line) else { return nil }

        self.color = match[1]

        let containedString = match[2]
        switch containedString {
        case "no other bags":
            contents = []

        case let things:
            contents = things
                .split(separator: ", ")
                .compactMap { ContainedBag($0) }
        }
    }

    func contents(using catalog: LuggageCatalog) -> [String] {
        let immediateBags = self.contents.reduce(into: [] as [String]) {
            (array, bag) in
            array.append(contentsOf: bag.contents)
        }

        return immediateBags +
            immediateBags.flatMap { catalog[$0]!.contents(using: catalog) }
    }

    func allPossibleContainers(using rules: LuggageCatalog) -> Set<String> {
        let bagsByPossibleContainers = rules.colorsToContainingColors

        var knownContainers: Set<String> = []
        var newlyAdded: Set<String> = [self.color]

        while newlyAdded.isEmpty == false {
            newlyAdded = Set(newlyAdded.flatMap { bagsByPossibleContainers[$0] ?? [] })
            newlyAdded.subtract(knownContainers)

            knownContainers.formUnion(newlyAdded)
        }
        return knownContainers
    }

}

struct ContainedBag: Hashable {
    var count: Int
    var color: String

    var contents: [String] {
        Array(repeating: color, count: count)
    }

    init(type: String, count: Int = 1) {
        self.color = type
        self.count = count
    }

    init?<Str>(_ line: Str) where Str: StringProtocol {
        let regex: Regex = #"(\d+) (.+) bags?"#

        guard let match = regex.match(line) else { return nil }

        self.count = Int(match[1])!
        self.color = match[2]
    }
}

