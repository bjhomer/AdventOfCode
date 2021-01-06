//
//  Day16.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

private let sampleInput = """
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

func day16(input inputData: Data) {
//    let input = sampleInput
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
}



extension Array where Element == Rule {
    func anyAccepts(_ value: Int) -> Bool {
        self.contains(where: { $0.accepts(value) } )
    }
}

private struct Rule {
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
}


private struct Ticket {
    var values: [Int]

    init<Str>(line: Str) where Str: StringProtocol {
        values = line.split(separator: ",").compactMap { Int($0) }
    }
}
