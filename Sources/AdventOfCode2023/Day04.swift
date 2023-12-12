import Algorithms
import AdventCore
import Foundation

struct Day04: AdventDay {

    private var cards: [Card]

    init(data: String) {
        cards = data.lines.compactMap { Card(line: $0) }
    }

    func part1() -> Int {
        return cards.map(\.score).reduce(0, +)
    }

    func part2() -> Int {
        var cardCounts = Array<Int>(repeating: 1, count: cards.count + 1)
        cardCounts[0] = 0

        for card in cards {
            let matchingCount = card.matchingCount
            let id = card.id
            for _ in 0..<cardCounts[id] {
                let incrementRange = id+1..<(id+matchingCount+1)
                for j in incrementRange {
                    cardCounts[j] += 1
                }
            }
        }
        return cardCounts.reduce(0, +)
    }
}

private struct Card: Hashable {
    var id: Int
    var winningNumbers: Set<Int>
    var numbers: Set<Int>

    init?(line: Substring) {
        guard let (idSection, numbersSection) = line.split(separator: ":").explode(),
              let idMatch = idSection.prefixMatch(of: /Card +(\d+)/),
              let (winning, card) = numbersSection.split(separator: "|").explode()
        else { return nil }

        id = Int(idMatch.1)!

        winningNumbers = winning.split(separator: " ")
            .map { Int($0)! }
        |> { Set($0) }

        numbers = card.split(separator: " ")
            .map { Int($0)! }
        |> { Set($0) }
    }

    var matchingCount: Int {
        winningNumbers.intersection(numbers).count
    }

    var score: Int {
        if matchingCount == 0 { return 0 }
        return 1 << (matchingCount - 1)
    }
}
