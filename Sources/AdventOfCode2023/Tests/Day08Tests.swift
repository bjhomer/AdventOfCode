import XCTest

@testable import AdventOfCode2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day08Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """


    func testPart1() throws {
        let challenge = Day08(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 6)
    }

    func testPart2() throws {
        let data = """
        LR

        11A = (11B, XXX)
        11B = (XXX, 11Z)
        11Z = (11B, XXX)
        22A = (22B, XXX)
        22B = (22C, 22C)
        22C = (22Z, 22Z)
        22Z = (22B, 22B)
        XXX = (XXX, XXX)
        """

        let challenge = Day08(data: data)
        let answer = challenge.part2()
        XCTAssertEqual(answer, 6)
    }

//    func testCyclePath() {
//        let testData = """
//        LR
//
//        11A = (11B, XXX)
//        11B = (XXX, 11Z)
//        11Z = (11B, XXX)
//        22A = (22B, XXX)
//        22B = (22C, 22C)
//        22C = (22Z, 22Z)
//        22Z = (22B, 22B)
//        XXX = (XXX, XXX)
//        """
//
//        let challenge = Day08(data: testData)
////        let (path, length) = challenge.cyclePath(startingAt: "11A")
//        let expected = ["11A", "11B", "11Z"]
//
//        XCTAssertEqual(path, expected)
//        XCTAssertEqual(length, 2)
//    }
}
