//
//  CombinationsWithReplacementSequence.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/9/24.
//


struct CombinationsWithReplacementSequence<Base: Collection>: Sequence, IteratorProtocol {
    let base: Base
    var index: [Base.Index]

    init(base: Base, count: Int) {
        self.base = base
        self.index = Array(repeating: base.startIndex, count: count)
    }

    typealias Element = [Base.Element]

    mutating func next() -> Element? {
        if index.first == base.endIndex { return nil }
        let values = index.map { base[$0] }
        increment(&index)
        return values
    }

    func increment(_ index: inout [Base.Index]) {
        for subIndex in index.indices.reversed() {
            let nextValueForSubIndex = base.index(after: index[subIndex])
            index[subIndex] = nextValueForSubIndex

            if subIndex != 0 && index[subIndex] == base.endIndex {
                index[subIndex] = base.startIndex
                continue
            }
            else {
                return
            }
        }
    }
}