//: [Previous](@previous)

import Foundation

func day5() {

    let inputURL = Bundle.main.url(forResource: "Day5Input", withExtension: "txt")!
    let input = try! String(contentsOf: inputURL)

    var offsets = input.components(separatedBy: "\n").flatMap(Int.init)
    let range = 0..<offsets.count

    var stepCount = 0
    var position = 0

    while range.contains(position) {
        let offset = offsets[position]
        if offset >= 3 {
            offsets[position] -= 1
        } else {
            offsets[position] += 1
        }
        position = position + offset
        
        stepCount += 1
    }

    print(stepCount)

}
