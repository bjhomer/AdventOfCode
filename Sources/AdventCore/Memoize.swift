//
//  Memoize.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/11/24.
//

import Foundation

public func memoize<In: Hashable, Out>(_ f: @escaping (In) -> Out) -> (In) -> Out {
    var memo: [In: Out] = [:]
    return {
        if let result = memo[$0] {
            return result
        } else {
            let result = f($0)
            memo[$0] = result
            return result
        }
    }
}
