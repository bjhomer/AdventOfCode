//
//  Day11.swift
//  
//
//  Created by BJ Homer on 12/10/22.
//

import Foundation
import AdventCore

struct Day11: Day {
    private var monkeys: [Monkey]

    init(input: URL) async throws {
        let monkeys = try String(contentsOf: input, encoding: .utf8)
            .split(separator: "\n\n")
            .compactMap { Monkey(description: $0) }

        self.monkeys = monkeys

    }

    func part1() async {
        var monkeys = self.monkeys
        for _ in 0..<20 {
            for i in 0..<monkeys.count {
                let items = monkeys[i].throwItems(worryReductionFactor: 3)
                for item in items {
                    monkeys[item.destination].receiveItem(item.item)
                }
            }
        }

        let result = monkeys
            .sorted(on: \.itemsInspected)
            .suffix(2)
            .map(\.itemsInspected)
            .reduce(1, *)

        print(result)

    }

    func part2() async {

        let commonTestMultiple = monkeys.map(\.testDivisor).reduce(1, *)

        var monkeys = self.monkeys
        for _ in 1...10_000 {
            for i in 0..<monkeys.count {
                monkeys[i].modWorries(by: commonTestMultiple)
                let items = monkeys[i].throwItems(worryReductionFactor: 1)
                for item in items {
                    monkeys[item.destination].receiveItem(item.item)
                }
            }

//            if round.isMultiple(of: 1000) || round == 20 || round == 1{
//                print("\n== Round \(round) ==")
//                for monkey in monkeys {
//                    print("Monkey \(monkey.id) inspected items \(monkey.itemsInspected) times")
//                }
//            }
        }

        let result = monkeys
            .sorted(on: \.itemsInspected)
            .suffix(2)
            .map(\.itemsInspected)
            .reduce(1, *)

        print(result)
    }

}

/*
 Monkey 0:
   Starting items: 79, 98
   Operation: new = old * 19
   Test: divisible by 23
     If true: throw to monkey 2
     If false: throw to monkey 3
 */

private struct Monkey {
    var itemsInspected: Int = 0
    let id: String

    private var items: [Int]
    private var operation: (Int) -> Int
    let testDivisor: Int
    private let trueDestination: Int
    private let falseDestination: Int

    init?(description: some StringProtocol) {
        guard let (idLine, itemsLine, operationLine, testLine, trueLine, falseLine) = description
            .split(separator: "\n")
            .map({ String($0) })
            .explode()
        else { return nil }

        guard let id = idLine.firstMatch(of: #/Monkey (\d+):/#)?.1,
              case let itemList = itemsLine.suffix(afterFirst: ": ").split(separator: ", ").compactMap({ Int($0) }),
              let (operation, operationValue) = operationLine.suffix(afterFirst: "new = old ").split(separator: " ").explode(),
              let testDivisor = testLine.suffix(afterFirst: "divisible by ") => {Int($0)},
        let trueDestination = trueLine.suffix(afterFirst: "throw to monkey ") => {Int($0)},
        let falseDestination = falseLine.suffix(afterFirst: "throw to monkey ") => {Int($0)}
        else { return nil }

        self.id = String(id)
        self.items = itemList
        self.testDivisor = testDivisor
        self.trueDestination = trueDestination
        self.falseDestination = falseDestination

        switch (operation, operationValue) {
        case ("+", "old"):
            self.operation = { $0 + $0 }
        case ("+", let numStr):
            let num = Int(numStr)!
            self.operation = { $0 + num }
        case ("*", "old"):
            self.operation = { $0 * $0 }
        case ("*", let numStr):
            let num = Int(numStr)!
            self.operation = { $0 * num }
        default:
            fatalError("Unsupported operation: \(operation) \(operationValue)")
        }
    }

    mutating func throwItems(worryReductionFactor: Int) -> [(item: Int, destination: Int)] {
        let result = items.map { item in
            let newWorry = operation(item) / worryReductionFactor
            let destination = (newWorry % testDivisor == 0) ? trueDestination : falseDestination
            return (item: newWorry, destination: destination)
        }
        self.items.removeAll()
        self.itemsInspected += result.count
        return result
    }

    mutating func receiveItem(_ item: Int) {
        self.items.append(item)
    }

    mutating func modWorries(by factor: Int) {
        items = items.map { $0 % factor }
    }
}

