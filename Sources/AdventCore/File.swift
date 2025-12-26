//
//  RangeSet.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/24/25.
//

public extension RangeSet where Bound: Strideable, Bound.Stride: SignedInteger {
    
    var values: [Bound] {
        ranges.flatMap { Array($0) }
    }
}
