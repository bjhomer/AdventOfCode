//
//  Regex.swift
//  
//
//  Created by BJ Homer on 12/4/20.
//

import Foundation

struct Regex {
    struct Match {
        private let result: NSTextCheckingResult
        private let string: NSString

        init(_ result: NSTextCheckingResult, in str: String) {
            self.result = result
            self.string = str as NSString
        }

        subscript(_ index: Int) -> String? {
            guard index < result.numberOfRanges else { return nil }
            let range = result.range(at: index)
            return string.substring(with: range)
        }
    }

    private var regex: NSRegularExpression

    init(pattern: String)  {
        regex = try! NSRegularExpression(pattern: pattern)
    }

    func matches(in str: String) -> [Match] {
        return regex
            .matches(in: str, range: NSRange(str.startIndex..., in: str))
            .map({ Match($0, in: str) })
    }

    func match(_ str: String) -> Match? {
        self.matches(in: str).first
    }
}