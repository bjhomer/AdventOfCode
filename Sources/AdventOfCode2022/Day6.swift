//
//  Day6.swift
//  
//
//  Created by BJ Homer on 12/3/22.
//

import Foundation
import RegexBuilder

struct Day6: Day {
    
    var lines: [String]
    
    init(input: URL) async throws {
        lines = try input.allLines.map { String($0) }
    }
    
    func part1() async {
        let results = lines.compactMap { line -> Int? in
            guard let index = line.indexEndingUniqueSequence(length: 4) else { return nil }
            return line.offset(of: index)
        }
        
        print(results)
    }
    
    func part2() async {
        let results = lines.compactMap { line -> Int? in
            guard let index = line.indexEndingUniqueSequence(length: 14) else { return nil }
            return line.offset(of: index)
        }
    
        
        print(results)
    }
    
    
}


private extension String {
    func indexEndingUniqueSequence(length: Int) -> Index? {
        return windows(ofCount: length).first(where: \.allUnique)?.endIndex
    }
}
