import XCTest

@testable import AdventOfCode2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day01Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """
    
    func testPart1() throws {
        let challenge = Day01(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 142)
    }
    
    func testPart2() throws {
        let challenge = Day00(data: testData)
        XCTAssertEqual(String(describing: challenge.part2()), "32000")
    }
}
