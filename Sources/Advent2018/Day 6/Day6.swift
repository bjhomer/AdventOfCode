//
//  Day6.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/23/17.
//  Copyright © 2017 BJ Homer. All rights reserved.
//

import Foundation


private struct State: Hashable, Equatable, CustomStringConvertible {
    private var array: [Int]
    var index: Int
    init(_ array: [Int], index: Int) {
        self.array = array
        self.index = index
    }
    
    var hashValue: Int { return array.first! + (array.first! + array.last!) }
    
    static func ==(lhs: State, rhs: State) -> Bool {
        return lhs.array == rhs.array
    }
    
    var description: String {
        return array.description
    }
}

func day6() {
    
    let inputURL = Bundle.main.url(forResource: "Day6Input", withExtension: "txt")!
    let input = try! String(contentsOf: inputURL)
    var banks = input.components(separatedBy: .whitespacesAndNewlines).flatMap(Int.init)
    let bankCount = banks.count
    
    var knownStates = Set<State>()
    var stateIndex = 0
    var state = State(banks, index: stateIndex)
    
    while knownStates.contains(state) == false {
        knownStates.insert(state)
        
        let max = banks.max()!
        var index = banks.index(of: max)!
        
        var distributionCount = banks[index]
        banks[index] = 0
        
        while distributionCount > 0 {
            index = (index + 1) % bankCount
            banks[index] += 1
            distributionCount -= 1
        }
        
        stateIndex += 1
        state = State(banks, index: stateIndex)
    }
    
    print("Loop found after \(knownStates.count) cycles")
    
    let knownStateIndex = knownStates.index(of: state)!
    let knownState = knownStates[knownStateIndex]
    
    print("It was the \(knownState.index)th item")
    
    print("So the loop size is \(knownStates.count)-\(knownState.index)=\(knownStates.count-knownState.index)")
    
    
    
    
}
