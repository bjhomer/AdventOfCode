//
//  Day09.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/10/24.
//

import Foundation
import AdventCore

struct Day09: AdventDay {
    var fileMap: [Int?]

    init(data: String) {
        var fileMap: [Int?] = []
        fileMap.reserveCapacity(1024)

        var currentFileID = 0
        for pair in data.chunks(ofCount: 2) {
            let ints = pair.compactMap { $0.int }
            let file = Array(repeating: currentFileID, count: ints[0])
            fileMap.append(contentsOf: file)

            if ints.count == 2 {
                let space = Array(repeating: (Int?).none, count: ints[1])
                fileMap.append(contentsOf: space)
            }
            currentFileID += 1
        }
        self.fileMap = fileMap
    }

    func part1() -> Int {
        let compacted = compacted(fileMap)
        return checksum(compacted)
    }

    func part2() -> Int {
        let compacted = partiallyCompacted(fileMap)
        return checksum(compacted)
    }

    func compacted(_ fileMap: [Int?]) -> [Int?] {
        var modifiedMap = fileMap
        var firstFreeIndex: Int? = modifiedMap.firstIndex(of: nil)
        var lastFileIndex: Int? = modifiedMap.lastIndex(where: { $0 != nil })
        var slice = modifiedMap[firstFreeIndex!...lastFileIndex!]

//        print(modifiedMap.map { $0.map(\.string) ?? "." }.joined())

        while firstFreeIndex != nil, lastFileIndex != nil, firstFreeIndex! < lastFileIndex! {
            slice = slice[firstFreeIndex!...lastFileIndex!]
            modifiedMap[firstFreeIndex!] = modifiedMap[lastFileIndex!]
            modifiedMap[lastFileIndex!] = nil
            slice = slice.dropFirst().dropLast()
            firstFreeIndex = slice.firstIndex(of: nil)
            lastFileIndex = slice.lastIndex(where: { $0 != nil })
//            print(modifiedMap.map { $0.map(\.string) ?? "." }.joined())
        }
        return modifiedMap
    }

    func partiallyCompacted(_ fileMap: [Int?]) -> [Int?] {
        var modifiedMap = fileMap
        var firstFreeIndex: Int? = modifiedMap.firstIndex(of: nil)
        var lastFileIndex: Int? = modifiedMap.lastIndex(where: { $0 != nil })
        var slice = modifiedMap[firstFreeIndex!...lastFileIndex!]

//                print(modifiedMap.map { $0.map(\.string) ?? "." }.joined())

        while firstFreeIndex != nil,
              lastFileIndex != nil,
              firstFreeIndex! < lastFileIndex!
        {
            slice = modifiedMap[firstFreeIndex!...lastFileIndex!]

            let fileID = slice[lastFileIndex!]
            let startOfFile = slice.lastIndex(where: { $0 != fileID })! + 1
            let fileRange = startOfFile..<slice.endIndex
            let emptySpace = Array(repeating: Int?.none, count: fileRange.count)

            if let firstFittingGap = slice.firstRange(of: emptySpace) {
                modifiedMap[firstFittingGap] = modifiedMap[fileRange]
                modifiedMap[fileRange] = emptySpace[...]
            }
            slice = slice[..<fileRange.lowerBound]

            firstFreeIndex = slice.firstIndex(of: nil)
            lastFileIndex = slice.lastIndex(where: { $0 != nil })
//                        print(modifiedMap.map { $0.map(\.string) ?? "." }.joined())
//            print(slice.map { $0.map(\.string) ?? "." }.joined())
        }
        return modifiedMap
    }

    func checksum(_ fileMap: [Int?]) -> Int {
        fileMap.indexed()
            .map { (idx, id) in id.map { idx * $0 } ?? 0 }
            .reduce(0, +)
    }
}
