//
//  File.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation

public extension StringProtocol {
    func split<Str>(separator: Str) -> [SubSequence]
    where Str: StringProtocol
    {
        if separator.count == 1 {
            return split(separator: separator.first!)
        }
        else {
            return self.splitImpl(separator: separator)
        }
    }

    var lines: [SubSequence] {
        return self.split(separator: "\n")
    }
}

public extension Substring {
    var string: String { String(self) }
}
