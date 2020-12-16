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
            let amountToAdd = abs(self/divisor)+4
            return self + amountToAdd
        }
    }
}
