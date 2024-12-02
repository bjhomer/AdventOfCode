import Algorithms
import SE0270_RangeSet
import AdventCore
import Foundation
import Collections

struct Day07: AdventDay {

    var handBids: [HandBid]
    var handBidsWithJokers: [HandBid]

    init(data: String) {
        handBids = data
            .lines
            .compactMap { HandBid(line: $0) }

        handBidsWithJokers = data
            .lines
            .compactMap { HandBid(line: $0, jokers: true) }
    }

    func part1() -> Int {
        let values = handBids
            .sorted(on: \.hand)
            .enumerated()
            .map { (i, handBid) in
                (handBid.hand, (i+1) * handBid.bid)
            }

        let result = values.map(\.1).reduce(0,+)
        return result
    }

    func part2() -> Int {
        let values = handBidsWithJokers
            .sorted(on: \.hand)
            .enumerated()
            .map { (i, handBid) in
                (handBid.hand, (i+1) * handBid.bid)
            }

        let result = values.map(\.1).reduce(0,+)
        return result
    }
}


extension Day07 {
    struct Hand: Comparable, CustomDebugStringConvertible, CustomStringConvertible {

        var cards: [Card]
        var usesJokers: Bool

        var type: HandType { .init(self) }

        init(_ str: Substring, jokers: Bool = false) {
            cards = str.compactMap { Card($0, jokers: jokers) }
            usesJokers = jokers
        }

        static func < (lhs: Day07.Hand, rhs: Day07.Hand) -> Bool {
            guard lhs.type == rhs.type else { return lhs.type < rhs.type }
            guard lhs.cards == rhs.cards else {
                return lhs.cards.lexicographicallyPrecedes(rhs.cards)
            }
            return false
        }

        var debugDescription: String {
            cards.map(\.debugDescription).joined()
        }

        var description: String {
            debugDescription
        }

    }

    enum HandType: Int, Comparable {
        case highCard
        case onePair
        case twoPair
        case threeOfAKind
        case fullHouse
        case fourOfAKind
        case fiveOfAKind

        var value: Int { rawValue + 1 }

        init(_ hand: Hand) {
            var cardCounts = hand.cards
                .grouped(by: { $0 })
                .mapValues { $0.count }

            if hand.usesJokers {
                let joker = Card("J", jokers: true)
                let jokerCount = cardCounts[joker] ?? 0
                cardCounts[joker] = 0
                let nextHighest = cardCounts
                    .sorted(on: \.value)
                    .last!
                    .key
                cardCounts[nextHighest, default: 0] += jokerCount
            }

            let groupCounts = cardCounts
                .map { $0.value }
                .sorted()
                .drop(while: { $0 == 0 })
                .reversed()
                .collect()


            self = switch groupCounts {
            case [5]: .fiveOfAKind
            case [4, 1]: .fourOfAKind
            case [3, 2]: .fullHouse
            case [3, 1, 1]: .threeOfAKind
            case [2, 2, 1]: .twoPair
            case [2, 1, 1, 1]: .onePair
            case [1, 1, 1, 1, 1]: .highCard
            default: fatalError()
            }
        }

        static func < (lhs: Day07.HandType, rhs: Day07.HandType) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    struct HandBid {
        var hand: Hand
        var bid: Int

        init?(line: Substring, jokers: Bool = false) {
            guard let (handStr, bidStr) = line.split(separator: " ").explode()
            else { return nil }

            hand = Hand(handStr, jokers: jokers)
            bid = Int(bidStr)!
        }
    }

    struct Card: Comparable, Hashable, CustomDebugStringConvertible {

        var value: Int

        init(_ char: Character, jokers: Bool = false) {
            switch char {
            case let x where x.isWholeNumber:
                value = x.wholeNumberValue!
            case "T":
                value = 10
            case "J":
                value = jokers ? 1 : 11
            case "Q":
                value = 12
            case "K":
                value = 13
            case "A":
                value = 14
            default:
                fatalError()
            }
        }

        static func < (lhs: Day07.Card, rhs: Day07.Card) -> Bool {
            lhs.value < rhs.value
        }

        var debugDescription: String {
            switch value {
            case 1: return "J"
            case 2...9: return "\(value)"
            case 10: return "T"
            case 11: return "J"
            case 12: return "Q"
            case 13: return "K"
            case 14: return "A"
            default: fatalError()
            }
        }

    }

}


