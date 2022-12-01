//
//  URL.swift
//  
//
//  Created by BJ Homer on 12/1/22.
//

import Foundation


public extension URL {
    var allLines: [Substring] {
        get throws {
            let data = try Data(contentsOf: self)
            let strings = String(decoding: data, as: UTF8.self)
                .split(separator: "\n", omittingEmptySubsequences: false)
            return strings
        }
    }
}
