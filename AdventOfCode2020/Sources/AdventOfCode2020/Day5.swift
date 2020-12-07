//
//  Day5.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation

func day5(input: Data) {
    let lines = String(decoding: input, as: UTF8.self)
        .split(separator: "\n")

    let seats = lines.map(Seat.init)

    let part1 = seats.map(\.number).max()!
    print("------")
    print("Part 1")
    print(part1)

    let occupiedSeats = seats.map(\.number)
    let part2 = Set(1...1024)
        .subtracting(occupiedSeats)
        .sorted()
        .chunked(by: { $0 + 1 == $1 })
        .filter { $0.count == 1 } // Drop contiguous runs of open seats
        .first! // Get the remaining chunk of just one seat
        .first! // Get the first seat in that chunk

    print("------")
    print("Part 2")
    print(part2)

}


struct Seat {
    var number: Int

    init<S>(_ str: S) where S: StringProtocol {
        let binaryString = str.map { (char) -> String in
            switch char {
            case "F", "L": return "0"
            case "B", "R": return "1"
            default: fatalError("Invalid input")
            }
        }
        .joined()

        self.number = Int(binaryString, radix: 2)!
    }
}
