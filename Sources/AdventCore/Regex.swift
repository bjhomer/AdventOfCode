//
//  Regex.swift
//  
//
//  Created by BJ Homer on 12/4/20.
//

import Foundation

public struct ACRegex: Sendable {
    public struct Match {
        private let result: NSTextCheckingResult
        private let string: NSString

        init(_ result: NSTextCheckingResult, in str: String) {
            self.result = result
            self.string = str as NSString
        }

        public subscript(_ index: Int) -> String {
            let range = result.range(at: index)
            return string.substring(with: range)
        }
    }

    private var regex: NSRegularExpression

    public init(_ pattern: String)  {
        regex = try! NSRegularExpression(pattern: pattern)
    }

    public func matches<S>(in optStr: S?) -> [Match] where S: StringProtocol  {
        guard let str = optStr.map(String.init(_:)) else { return [] }
        return regex
            .matches(in: str, range: NSRange(str.startIndex..., in: str))
            .map({ Match($0, in: str) })
    }

    public func match<S>(_ optStr: S?) -> Match? where S: StringProtocol {
        guard let str = optStr else { return nil }
        return self.matches(in: str).first
    }
}

extension ACRegex: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension ACRegex.Match: Collection {
    public func index(after i: Int) -> Int { i + 1 }

    public var startIndex: Int { 0 }
    public var endIndex: Int { result.numberOfRanges }
}
