//
//  Day12Tests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Testing
@testable import Advent2024
import AdventCore

struct Day13Tests {
    let testData1 = """
    Button A: X+94, Y+34
    Button B: X+22, Y+67
    Prize: X=8400, Y=5400
    
    Button A: X+26, Y+66
    Button B: X+67, Y+21
    Prize: X=12748, Y=12176
    
    Button A: X+17, Y+86
    Button B: X+84, Y+37
    Prize: X=7870, Y=6450
    
    Button A: X+69, Y+23
    Button B: X+27, Y+71
    Prize: X=18641, Y=10279
    """
    
    let testMachine1Data = """
        Button A: X+94, Y+34
        Button B: X+22, Y+67
        Prize: X=8400, Y=5400
        """
    
    let testMachine2Data = """
        Button A: X+26, Y+66
        Button B: X+67, Y+21
        Prize: X=12748, Y=12176
        """
    
    let testMachine3Data = """
        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450
        """
    
    let testMachine4Data = """
        Button A: X+17, Y+86
        Button B: X+84, Y+37
        Prize: X=7870, Y=6450
    """
        
    @Test func testParsing() {
        let day = Day13(data: testData1)
        #expect(day.arcades.count == 4)
    }
    
    @Test func testParsingArcade() {
        let arcade = Day13.Arcade(data: testMachine1Data[...])
        #expect(arcade != nil)
    }
    
    @Test func testLinearBasis() throws {
        let testLinearBasisData = """
            Button A: X+1, Y+0
            Button B: X+0, Y+1
            Prize: X=44, Y=20
            """
        
        let arcade = try #require(Day13.Arcade(data: testLinearBasisData[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 44 && b == 20)
    }
    
    @Test func testLinearBasis2() throws {
        let testLinearBasisData = """
            Button A: X+1, Y+1
            Button B: X+0, Y+1
            Prize: X=20, Y=44
            """
        
        let arcade = try #require(Day13.Arcade(data: testLinearBasisData[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 20 && b == 24)
    }
    
    @Test func testMachine1() throws {
        let arcade = try #require(Day13.Arcade(data: testMachine1Data[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 80 && b == 40)
    }
    
    @Test func testMachine1Solution() throws {
        let day = Day13(data: testMachine1Data)
        #expect(day.part1() == 280)
    }
    
    @Test func testMachine3Solution() throws {
        let day = Day13(data: testMachine3Data)
        #expect(day.part1() == 200)
    }
    
    @Test func testAlignedButtons() throws {
        let alignedData = """
            Button A: X+2, Y+4
            Button B: X+3, Y+6
            Prize: X=7, Y=14
            """
        let arcade = try #require(Day13.Arcade(data: alignedData[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 2)
        #expect(b == 1)
    }    
    
    @Test func testAlignedButtonsImpossible() throws {
        let alignedData = """
            Button A: X+2, Y+4
            Button B: X+3, Y+6
            Prize: X=7, Y=15
            """
        let arcade = try #require(Day13.Arcade(data: alignedData[...]))
        let result = arcade.buttonsToSolve()
        #expect(result == nil)
    }
    
    @Test func testAlignedButtonsMoreComplex() throws {
        let alignedData = """
            Button A: X+2, Y+4
            Button B: X+3, Y+6
            Prize: X=11, Y=22
            """
        let arcade = try #require(Day13.Arcade(data: alignedData[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 1)
        #expect(b == 3)
    }
    
    
    @Test func input318() throws {
        let inputData = """
            Button A: X+99, Y+23
            Button B: X+80, Y+87
            Prize: X=4029, Y=1757
            """
        
        let arcade = try #require(Day13.Arcade(data: inputData[...]))
        let (a, b) = try #require(arcade.buttonsToSolve())
        #expect(a == 31)
        #expect(b == 12)
    }

    @Test func part1() {
        let day = Day13(data: testData1)
        #expect(day.part1() == 480)
    }
}
