import XCTest

@testable import Advent2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day06Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    func testSample1() {
        let record = Day06.RaceRecord(time: 7, recordDistance: 9)
        let results = record.chargingTimesToBeatRecord()
        XCTAssertEqual(results, 2...5)
    }

    func testSample2() {
        let record = Day06.RaceRecord(time: 15, recordDistance: 40)
        let results = record.chargingTimesToBeatRecord()
        XCTAssertEqual(results, 4...11)
    }

    func testSample3() {
        let record = Day06.RaceRecord(time: 30, recordDistance: 200)
        let results = record.chargingTimesToBeatRecord()
        XCTAssertEqual(results, 11...19)
    }

    func testPart1() throws {
        let challenge = Day06(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 288)
    }

    func testPart2() throws {
        let challenge = Day06(data: testData)
        let answer = challenge.part2()
        XCTAssertEqual(answer, 71503)
    }
}
