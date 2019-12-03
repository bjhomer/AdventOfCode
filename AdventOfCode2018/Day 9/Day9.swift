//
//  Day7.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/23/17.
//  Copyright © 2017 BJ Homer. All rights reserved.
//

import Foundation


private var totalGarbageCount = 0

func day9() {
    
    
    let inputURL = Bundle.main.url(forResource: "Day9Input", withExtension: "txt")!
    let rawInput = try! String(contentsOf: inputURL)
    let input = rawInput.components(separatedBy: "\n")[0]
//    let input = "{<!!!>>}"
    
    struct Group {
        private var value: Int
        
        func wholeValue() -> Int {
            let childValues = childGroups.map({ $0.wholeValue() })
            return self.value + childValues.reduce(0, +)
        }
        
        private var childGroups: [Group] = []
        
        init(value: Int) {
            self.value = value
        }
        
        mutating func addChild(_ group: Group) {
            assert(group.value == self.value + 1)
            childGroups.append(group)
        }
        
        static func parseGroup(_ string: Substring, value: Int=1) -> (Group, Substring) {
            let openBrace = string.prefix(1)
            guard openBrace == "{" else {
                print("Tried to parse a string that wasn't a group")
                fatalError()
            }
            
            var group = Group(value: value)
            var remainder = string[openBrace.endIndex...]
            
            loop:
            while remainder.isEmpty == false {
                
                if remainder.hasPrefix(",") {
                    remainder = remainder.dropFirst()
                }
                
                switch remainder.first! {
                case "<":
                    let (_, newRemainder, garbageCharCount) = parseGarbage(remainder)
                    remainder = newRemainder
                    totalGarbageCount += garbageCharCount
                    continue
                case "{":
                    let (childGroup, newRemainder) = parseGroup(remainder, value: value+1)
                    remainder = newRemainder
                    group.addChild(childGroup)
                case "}":
                    remainder = remainder.dropFirst()
                    break loop
                case let other:
                    fatalError("Unexpected first character: \(other)")
                }
            }
            
            return (group, remainder)
        }
        
        private static func parseGarbage(_ rawContents: Substring) -> (garbage: Substring, remainder: Substring, garbageCharCount: Int) {
            var ignoreNext = false
            var garbageCharCount = 0
            
            assert(rawContents.first == "<")
            let contents = rawContents.dropFirst()
            
            let stuff = zip(contents.indices, contents)
            for (index, x) in stuff {
                if ignoreNext { ignoreNext = false; continue }
                if x == ">" {
                    let nextIndex = contents.index(after: index)
                    return (contents[...index], contents[nextIndex...], garbageCharCount)
                }
                else if x == "!" {
                    ignoreNext = true
                }
                else {
                    garbageCharCount += 1
                }
                
            }
            fatalError("We never found the end of the garbage")
        }
        
    }
    
    let (g, _) = Group.parseGroup(input[...])
    print(g.wholeValue())
    print(totalGarbageCount)
}
