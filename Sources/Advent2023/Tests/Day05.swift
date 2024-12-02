import XCTest

@testable import Advent2023

// Make a copy of this file for every day to ensure the provided smoke tests
// pass.
final class Day05Tests: XCTestCase {
    // Smoke test data provided in the challenge question
    let testData = """
    seeds: 79 14 55 13

    seed-to-soil map:
    50 98 2
    52 50 48

    soil-to-fertilizer map:
    0 15 37
    37 52 2
    39 0 15

    fertilizer-to-water map:
    49 53 8
    0 11 42
    42 0 7
    57 7 4

    water-to-light map:
    88 18 7
    18 25 70

    light-to-temperature map:
    45 77 23
    81 45 19
    68 64 13

    temperature-to-humidity map:
    0 69 1
    1 0 69

    humidity-to-location map:
    60 56 37
    56 93 4
    """

    func testPart1() throws {
        let challenge = Day05(data: testData)
        let answer = challenge.part1()
        XCTAssertEqual(answer, 35)
    }

    func testPart2() throws {
        let challenge = Day05(data: testData)
        let answer = challenge.part2()
        XCTAssertEqual(answer, 46)
    }

    func testCompsingMappings() {
        var map1 = Day05.Map()
        map1.insert(.init(sourceRange: 3..<8, offset: 10))

        var map2 = Day05.Map()
        map2.insert( .init(sourceRange: 13..<15, offset: 15))

        let composed = map1.composed(with: map2)

        let expectedResults = [
            (0, 0),
            (1, 1),
            (2, 2),
            (3, 28),
            (4, 29),
            (5, 15),
            (6, 16),
            (7, 17),
            (8, 8),
            (9, 9)
        ]

        for (x, y) in expectedResults {
            XCTAssertEqual(composed.value(for: x), y)
        }
    }

    func testIterativeMaps() {
        let day = Day05(data: testData)

        let compositions = day.maps.reductions(Day05.Map()) { a, b in
            a.composed(with: b)
        }

        let prefixes = day.maps.reductions([]) { r, map in
            r + [map]
        }

        let pairs = zip(compositions, prefixes)

        for (composed, path) in pairs {
            for i in 0..<100 {
                let c = composed.value(for: i)
                let p = path.reduce(i) { partialResult, map in
                    map.value(for: partialResult)
                }
                XCTAssertEqual(c, p)
            }
        }
    }

    func testComposingIntoEmpty() {
        let map1 = Day05.Map()

        var map2 = Day05.Map()
        map2.insert(.init(sourceRange: 13..<15, offset: 15))

        let composed = map1.composed(with: map2)

        XCTAssertEqual(composed.mappedRanges, map2.mappedRanges)
    }
}
