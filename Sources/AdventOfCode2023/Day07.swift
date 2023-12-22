import Algorithms
import SE0270_RangeSet
import AdventCore
import Foundation
import Collections

struct Day07: AdventDay {

    var handBids: [HandBid]

    init(data: String) {
        handBids = data
            .lines
            .compactMap { HandBid(line: $0) }
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
        0
    }
}


extension Day07 {
    struct Hand: Comparable, CustomDebugStringConvertible, CustomStringConvertible {

        var cards: [Card]
        var type: HandType { .init(self) }

        init(_ str: Substring) {
            cards = str.compactMap { Card($0) }
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
            let cardCounts = hand.cards
                .grouped(by: { $0 })
                .map { $0.value.count }
                .sorted()
                .reversed()
                .collect()

            self = switch cardCounts {
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

        init?(line: Substring) {
            guard let (handStr, bidStr) = line.split(separator: " ").explode()
            else { return nil }

            hand = Hand(handStr)
            bid = Int(bidStr)!
        }
    }

    struct Card: Comparable, Hashable, CustomDebugStringConvertible {
        var value: Int

        init?(_ char: Character) {
            switch char {
            case let x where x.isWholeNumber:
                value = x.wholeNumberValue!
            case "T":
                value = 10
            case "J":
                value = 11
            case "Q":
                value = 12
            case "K":
                value = 13
            case "A":
                value = 14
            default:
                return nil
            }
        }

        static func < (lhs: Day07.Card, rhs: Day07.Card) -> Bool {
            lhs.value < rhs.value
        }

        var debugDescription: String {
            switch value {
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


