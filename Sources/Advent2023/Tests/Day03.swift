import XCTest

@testable import Advent2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day03Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    467..114..
    ...*......
    ..35..633.
    ......#...
    617*......
    .....+.58.
    ..592.....
    ......755.
    ...$.*....
    .664.598..
    """

    func testPart1() throws {
        let challenge = Day03(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 4361)
    }

    func testPart2() throws {
        let challenge = Day03(data: testData)
        let answer = challenge.part2()
        XCTAssertEqual(answer, 467835)
    }
}
