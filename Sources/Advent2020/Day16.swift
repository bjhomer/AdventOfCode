//
//  Day16.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

private let sampleInput1 = """
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
"""

private let sampleInput2 = """
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
"""

func day16(input inputData: Data) {
//    let input = sampleInput2
    let input = String(decoding: inputData, as: UTF8.self)

    let (rulesStr, ticketStr, nearbyStr) = input
        .split(separator: "\n\n")
        .explode()!

    let rules = rulesStr.lines.compactMap { Rule(line: $0) }
    let myTicket = Ticket(line: ticketStr.lines[1])
    let nearbyTickets = nearbyStr.lines.dropFirst().compactMap{ Ticket(line: $0) }

    let invalidValues = nearbyTickets
        .flatMap { (ticket) in
            ticket.values.filter { rules.anyAccepts($0) == false }
        }

    let part1 = invalidValues.reduce(0, +)
    print("Part 1: \(part1)")

    let validTickets = nearbyTickets.filter { rules.isValidTicket($0) }

    let ruleAssignments = assignRulePositions(rules, using: validTickets)
    print("Assigned rules:", ruleAssignments.map(\.name) )

    myTicket.print(using: ruleAssignments)

    let part2 = myTicket
        .fields(using: ruleAssignments)
        .filter { (name, value) in name.hasPrefix("departure") }
        .map { (name, value) in value }
        .reduce(1, *)

    print("Part 2: \( part2 )")
}

extension Array where Element == Rule {
    func anyAccepts(_ value: Int) -> Bool {
        self.contains(where: { $0.accepts(value) } )
    }

    func anyAccepts(_ values: [Int]) -> Bool {
        self.contains(where: { $0.accepts(values) })
    }

    func isValidTicket(_ ticket: Ticket) -> Bool {
        for value in ticket.values {
            if anyAccepts(value) == false { return false }
        }
        return true
    }
}

private struct Rule: Hashable {
    var name: String
    var validRanges: [ClosedRange<Int>]

    init?<Str: StringProtocol>(line: Str) {
        guard let (name, rangeStr) = line.split(separator: ": ").explode()
        else { return nil }

        self.name = String(name)

        self.validRanges = rangeStr
            .split(separator: " or ")
            .map { (str) in
                let (start, end) = str
                    .split(separator: "-")
                    .map{ Int($0)! }
                    .explode()!
                return start...end
            }
    }

    func accepts(_ value: Int) -> Bool {
        return validRanges.contains(where: { $0.contains(value) } )
    }

    func accepts(_ values: [Int]) -> Bool {
        return values.allSatisfy { self.accepts($0) }
    }
}

private func assignRulePositions(_ rules: [Rule], using tickets: [Ticket]) -> [Rule] {
    var possibleAssignments: [Int: Set<Rule>] = [:]
    var availableRules = Set(rules)
    var assignments: [Int: Rule] = [:]

    let fields = Array(0..<rules.count)

    for i in 0..<rules.count {
        possibleAssignments[i] = Set(rules)
    }

    while availableRules.isEmpty == false {
        for field in fields {
            var fieldPossibilities: Set<Rule> {
                get { possibleAssignments[field]! }
                set { possibleAssignments[field] = newValue }
            }

            let invalidRules = tickets.invalidRules(from: rules, forField: field)
            fieldPossibilities.subtract(invalidRules)

            if fieldPossibilities.count == 1 {
                // We found a match!
                let rule = fieldPossibilities.first!
                assignments[field] = rule
                availableRules.remove(rule)
                for otherField in fields where otherField != field {
                    possibleAssignments[otherField]!.remove(rule)
                }
            }
        }
    }


    let sortedRules = assignments.keys.sorted().map { assignments[$0]! }
    return sortedRules

}


private struct Ticket: Hashable {
    var values: [Int]

    init<Str>(line: Str) where Str: StringProtocol {
        values = line.split(separator: ",").compactMap { Int($0) }
    }

    func print(using rules: [Rule]) {
        let pairs = zip(rules.map(\.name), values)

        for x in pairs {
            Swift.print("  \(x.0) -> \(x.1)")
        }
    }

    func fields(using rules: [Rule]) -> [String: Int] {
        Dictionary(uniqueKeysWithValues: zip(rules.map(\.name), values) )
    }
}


extension Array where Element == Ticket {
    func invalidRules(from rules: [Rule], forField field: Int) -> [Rule] {
        let allValues = self.map { $0.values[field] }
        let invalidRules = rules.filter { $0.accepts(allValues) == false }
        return invalidRules
    }
}
