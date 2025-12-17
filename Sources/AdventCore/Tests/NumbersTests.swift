//
//  NumbersTests.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/1/25.
//

import Testing

struct NumbersTests {

    @Test func testPositiveMod() async throws {
        #expect( (-1).positiveMod(7) == 6)
        #expect( (-2).positiveMod(7) == 5)
        #expect( (-3).positiveMod(7) == 4)
        #expect( (-4).positiveMod(7) == 3)
        #expect( (-5).positiveMod(7) == 2)
        #expect( (-7).positiveMod(7) == 0)
        #expect( (-8).positiveMod(7) == 6)
    }
    
    @Test func repeatDigits() async throws {
        #expect( 0.repeatDigits(4) == 0)
        #expect( (130).repeatDigits(3) == 130130130 )
        #expect( (552).repeatDigits(0) == 0 )
        #expect( (-3).repeatDigits(4) == -3333 )
    }

}
