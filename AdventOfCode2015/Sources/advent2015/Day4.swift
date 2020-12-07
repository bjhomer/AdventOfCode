//
//  Day4.swift
//  
//
//  Created by BJ Homer on 12/6/20.
//

import Foundation
import CryptoKit
import Algorithms

func day4(input: String) {
    let prefix = input.trimmingCharacters(in: .whitespacesAndNewlines)
    var part1: Int! = nil
    for i in 0...Int.max {
        if i % 10000 == 0 {
            print(i)
        }
        let str = prefix.appending("\(i)")
        let data = Data(str.utf8)
        let hash = CryptoKit.Insecure.MD5.hash(data: data)
        let hex = hash.hexString
        if hex.hasPrefix("00000") {
            part1 = i
            print("Part 1:", i)
            break
        }
    }
    for i in part1...Int.max {
        let str = prefix.appending("\(i)")
        let data = Data(str.utf8)
        let hash = CryptoKit.Insecure.MD5.hash(data: data)
        let hex = hash.hexString
        if hex.hasPrefix("000000") {
            print("Part 2", i)
            break
        }
    }
//
}

extension Digest {
    var hexString: String { self.map({ String(format: "%02x", $0) }).joined() }
}
