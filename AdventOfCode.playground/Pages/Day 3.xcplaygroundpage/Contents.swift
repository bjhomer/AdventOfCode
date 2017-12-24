//: [Previous](@previous)

import Foundation

struct Ring {
    init(_ index: Int) {
        self.index = index
    }
    
    init(containing value: Int) {
        for n in 1...1000 {
            let ring = Ring(n)
            if value <= ring.maxValue {
                self = ring
                return
            }
        }
        fatalError("There should definitely be a ring for \(value)")
    }
    
    var index: Int
    var range: CountableClosedRange<Int> {
        let previousMax = Ring(index-1).maxValue
        return (previousMax+1)...maxValue
    }
    var maxValue: Int {
        return (2*index-1) * (2*index-1)
    }
    var size: Int {
        return maxValue - Ring(index-1).maxValue
    }
    
    var positions: [Position] {
        return Array(IteratorSequence(PositionIterator(ring: self)))
    }
    
    func index(of value: Int) -> Int? {
        guard range.contains(value) else { return nil }
        return value - range.lowerBound
    }
    
    struct Position: Equatable, Hashable, CustomStringConvertible {
        var x: Int
        var y: Int
        
        var description: String {
            return "(\(x), \(y))"
        }
        
        static func == (lhs: Position, rhs: Position)->Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }
        
        var hashValue: Int {
            return x * 139 + y
        }
        
        var above: Position {
            return Position(x: x, y: y+1)
        }
        
        var below: Position {
            return Position(x: x, y: y-1)
        }
        
        var left: Position {
            return Position(x: x-1, y: y)
        }
        
        var right: Position {
            return Position(x: x+1, y: y)
        }
    }
    
    struct PositionIterator: IteratorProtocol {
        
        private var ring: Ring
        private var nextPosition: Position?
        private var end: Position
        
        init(ring: Ring) {
            self.ring = ring
            self.nextPosition = Position(x: ring.index-1, y: -(ring.index-1)+1)
            self.end = Position(x: ring.index-1, y: -(ring.index-1))
        }
        
        mutating func next() -> Position? {
            guard let value = nextPosition else { return nil }
            
            let r = ring.index-1
            
            if r == 0 {
                nextPosition = nil
                return self.end
            }
        
            var offset: (Int, Int)
            switch (value.x, value.y) {
            case (end.x, end.y): nextPosition = nil; return value
            case (r, -r..<r): offset = (0, 1)
            case ((-r+1)...r, r): offset = (-1, 0)
            case (-r, (-r+1)...r): offset = (0, -1)
            case (-r...r, -r): offset = (1, 0)
            default: fatalError("Unexpected case: \(value), r: \(r)")
            }
            
            nextPosition = Position(x: value.x+offset.0, y: value.y+offset.1)
            
            return value
        }
    }
}

// Part 1
let input = 325489
//let r = Ring(containing: input)
//let p = r.positions[r.index(of: input)!]
//
//print(abs(p.x) + abs(p.y))


// Part 2

var knownValues: [Ring.Position: Int] = [:]
knownValues[Ring.Position(x:0, y:0)] = 1

outer: for i in (2...).prefix(10) {
    let ring = Ring(i)
    for position in ring.positions {
        let down = position.below
        let up = position.above
        let left = position.left
        let right = position.right
        let dl = down.left
        let dr = down.right
        let ul = up.left
        let ur = up.right
        
        let values = [down, up, left, right, dl, dr, ul, ur].map({
            knownValues[$0, default: 0]
        })
        
        let newValue = values.reduce(0, +)
        
        if newValue > input {
            print("part 2: \(newValue)")
            break outer
        }
        knownValues[position] = newValue
        
        print("\(position): \(newValue)")
    }
}

//: [Next](@next)

