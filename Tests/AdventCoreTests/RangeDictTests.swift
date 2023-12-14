//
//  RangeDictTests.swift
//  
//
//  Created by BJ Homer on 12/14/23.
//

import XCTest
import AdventCore

final class RangeDictTests: XCTestCase {

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {

    }

    func testEmptyRange() {
        let d = RangeDict<Int>()

        XCTAssertNil(d[0])
        XCTAssertNil(d[100])
    }

    func testSettingRange() {
        var d = RangeDict<String>()

        XCTAssertNil(d[5])

        d.setRange(1..<3, to: "hi")
        XCTAssertEqual(d[1], "hi")
        XCTAssertEqual(d[2], "hi")
        XCTAssertNil(d[3])
        XCTAssertNil(d[5])

        d.setRange(2..<5, to: "there")
        XCTAssertEqual(d[1], "hi")
        XCTAssertEqual(d[2], "there")
        XCTAssertEqual(d[3], "there")
        XCTAssertEqual(d[4], "there")
        XCTAssertEqual(d[5], nil)
        XCTAssertEqual(d[6], nil)
    }

    func testSettingOverlappingRange() {
        var d = RangeDict<String>()

        d.setRange(1..<10, to: "cow")

        XCTAssertEqual(d[5], "cow")
        XCTAssertEqual(d[0], nil)

        d.setRange(3..<7, to: "pig")
        XCTAssertEqual(d[2], "cow")
        XCTAssertEqual(d[5], "pig")
        XCTAssertEqual(d[7], "cow")
        XCTAssertEqual(d[10], nil)
    }
}
