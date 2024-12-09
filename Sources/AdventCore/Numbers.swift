//
//  Numbers.swift
//
//  Created by BJ Homer on 12/15/20.
//

import Foundation


public extension Int {
    func positiveMod(_ divisor: Int) -> Int {
        if self >= 0 { return self % abs(divisor) }
        else {
            let amountToAdd = abs(self/divisor)+divisor
            return self + amountToAdd
        }
    }

    func clamped(to range: ClosedRange<Int>) -> Int {
        [range.lowerBound, range.upperBound, self].sorted()[1]
    }

    var digitCount: Int {
        var count = 1
        var remainder = self / 10
        while remainder > 0 {
            count += 1
            remainder /= 10
        }
        return count
    }

    func pow(_ exponent: Int) -> Int {
        assert(exponent >= 0)
        if exponent == 0 { return 1 }
        var result = 1
        for _ in 1...exponent { result *= self }
        return result
    }
}

public func gcd(_ a: Int, _ b: Int) -> Int {
    if b == 0 { return a }
    return gcd(b, a % b)
}

public func lcm(_ a: Int, _ b: Int) -> Int {
    return a * b / gcd(a, b)
}
