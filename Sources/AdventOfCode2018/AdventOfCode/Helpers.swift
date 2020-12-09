//
//  Helpers.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/23/17.
//  Copyright © 2017 BJ Homer. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    func firstMatch(in string: String) -> NSTextCheckingResult?
    {
        let range = string.startIndex..<string.endIndex
        let nsRange = NSRange(range, in: string)
        return self.firstMatch(in: string, range: nsRange)
    }
}

extension NSTextCheckingResult {
    func substring(named name: String, in string: String) -> String? {
        let nsRange = self.range(withName: name)
        if let range = Range(nsRange, in: string) {
            return String(string[range])
        }
        else {
            return nil
        }
    }
}

struct MatchedString {
    private var string: String
    private var match: NSTextCheckingResult
    
    init(string: String, match: NSTextCheckingResult) {
        self.string = string
        self.match = match
    }
    
    func string(named: String) -> String? {
        let nsRange = match.range(withName: named)
        guard nsRange.location != NSNotFound,
            let range = Range(nsRange, in: self.string)
            else {
                return nil
        }
        return String(self.string[range])
    }
}

