import XCTest

@testable import Advent2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day07Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    func testParsingHandTypes() {
        let tests: [(String, Day07.HandType)] = [
            ("AAAAA", .fiveOfAKind),
            ("AA8AA", .fourOfAKind),
            ("23332", .fullHouse),
            ("TTT98", .threeOfAKind),
            ("23432", .twoPair),
            ("A23A4", .onePair),
            ("23456", .highCard),
            ("224J2", .threeOfAKind)
        ]

        for (str, expectedType) in tests {
            let hand = Day07.Hand(str[...])
            let type = Day07.HandType(hand)
            XCTAssertEqual(type, expectedType)
        }
    }

    func testParsingHandTypesWithJokers() {
        let tests: [(String, Day07.HandType)] = [
            ("J23K5", .onePair),
            ("T55J5", .fourOfAKind),
            ("32T3K", .onePair),
            ("KK677", .twoPair),
            ("KTJJT", .fourOfAKind),
            ("QQQJA", .fourOfAKind),
        ]

        for (str, expectedType) in tests {
            let hand = Day07.Hand(str[...], jokers: true)
            let type = Day07.HandType(hand)
            XCTAssertEqual(type, expectedType)
        }
    }

    func testSortingHands() {
        let testHands = [
            "57A83",
            "5QTK7",
            "224J2",
            "22JK9",
            "2445T"
        ]

        let sortedHands = testHands
            .map { Day07.Hand($0[...]) }
            .sorted()
            .map(\.debugDescription)


        let expectedSort = [
            "57A83",
            "5QTK7",
            "22JK9",
            "2445T",
            "224J2",
        ]

        XCTAssertEqual(sortedHands, expectedSort)
    }

    func testSortingHands2() {
        let testHands = [
            "33332",
            "2AAAA",
            "77888",
            "77788",
        ]

        let sortedHands = testHands
            .map { Day07.Hand($0[...]) }
            .sorted()
            .map(\.debugDescription)


        let expectedSort = [
            "77788",
            "77888",
            "2AAAA",
            "33332"
        ]

        XCTAssertEqual(sortedHands, expectedSort)
    }

    func testHandTypeValue() {
        let data: [(Day07.HandType, Int)] = [
            (.highCard, 1),
            (.onePair, 2),
            (.twoPair, 3),
            (.threeOfAKind, 4),
            (.fullHouse, 5),
            (.fourOfAKind, 6),
            (.fiveOfAKind, 7)
        ]

        for (type, expectedValue) in data {
            XCTAssertEqual(type.value, expectedValue)
        }
    }

    func testPart1() throws {
        let challenge = Day07(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 6440)
    }

    func testPart2() throws {
        let challenge = Day07(data: testData)
        let answer = challenge.part2()
        XCTAssertEqual(answer, 5905)
    }
}
