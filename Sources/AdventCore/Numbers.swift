//
//  File.swift
//  
//
//  Created by BJ Homer on 12/15/20.
//

import Foundation


extension Int {
    public func positiveMod(_ divisor: Int) -> Int {
        if self >= 0 { return self % abs(divisor) }
        else {
            let amountToAdd = abs(self/divisor)+divisor
            return self + amountToAdd
        }
    }

    public func clamped(to range: ClosedRange<Int>) -> Int {
        [range.lowerBound, range.upperBound, self].sorted()[1]
    }
}

public func gcd(_ a: Int, _ b: Int) -> Int {
    if b == 0 { return a }
    return gcd(b, a % b)
}

public func lcm(_ a: Int, _ b: Int) -> Int {
    return a * b / gcd(a, b)
}
