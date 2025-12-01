//
//  Day14Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

@Suite("2024.14 Tests")
struct Day14Tests {

    @Test func robotPosition() throws {
        let robot = try #require(Day14.Robot(line: "p=1,2 v=2,4"))
        let position = robot.position(after: 1, gridSize: (width: 7, height: 11))
        #expect(position == .init(x: 3, y: 6))
        
        let position2 = robot.position(after: 2, gridSize: (width: 7, height: 11))
        #expect(position2 == .init(x: 5, y: 10))
        
        let position3 = robot.position(after: 3, gridSize: (width: 7, height: 11))
        #expect(position3 == .init(x: 0, y: 3))
        
        let position4 = robot.position(after: 4, gridSize: (width: 7, height: 11))
        #expect(position4 == .init(x: 2, y: 7))
    }
    
    @Test func robotPositionNegativeVelocity() throws {
        let robot = try #require(Day14.Robot(line: "p=1,2 v=-2,-4"))
        let position = robot.position(after: 1, gridSize: (width: 7, height: 11))
        #expect(position == .init(x: 6, y: 9))
    }
    
    @Test func part1() {
        let sampleInput = """
            p=0,4 v=3,-3
            p=6,3 v=-1,-3
            p=10,3 v=-1,2
            p=2,0 v=2,-1
            p=0,0 v=1,3
            p=3,0 v=-2,-2
            p=7,6 v=-1,-3
            p=3,0 v=-1,-2
            p=9,3 v=2,3
            p=7,3 v=-1,2
            p=2,4 v=2,-3
            p=9,5 v=-3,-3
            """
        
        let day = Day14(data: sampleInput, width: 11, height: 7)
        #expect(day.part1() == 12)
    }
}
