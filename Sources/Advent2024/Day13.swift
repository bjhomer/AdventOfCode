//
//  Day12.swift
//  AdventOfCode
//
//  Created by BJ Homer on 12/13/24.
//

import Foundation
import AdventCore
@preconcurrency import Surge


struct Day13: AdventDay {
    
    var arcades: [Arcade]
    
    init(data: String) {
        arcades = data.split(separator: "\n\n")
            .compactMap { Arcade(data: $0) }
    }

    func part1() -> Int {
        let cost = arcades
            .indexed()
            .map {
                debug("\($0): \($1)")
                guard let (a, b) = $1.buttonsToSolve() else {
                    debug("  (none)")
                    return 0
                }
                debug("  (\(a), \(b)) -> \(a*3 + b)")
                return (a*3) + b
        }
        .reduce(0, +)
        return Int(cost)
    }
    
    func part2() -> Int {
        let fixedArcades = arcades.map { arcade in
            var newArcade = arcade
            newArcade.prize.x += 10000000000000
            newArcade.prize.y += 10000000000000
            return newArcade
        }
        
        var newDay = Day13()
        newDay.arcades = fixedArcades
        return newDay.part1()
    }
}

extension Day13 {
    struct Arcade {
        var aIncrement: GridPoint
        var bIncrement: GridPoint
        var prize: GridPoint
        
        init?(data: Substring) {
            let regex = Regex {
                /Button A: X\+(\d+), Y\+(\d+)/
                "\n"
                /Button B: X\+(\d+), Y\+(\d+)/
                "\n"
                /Prize: X=(\d+), Y=(\d+)/
            }
            
            guard let matches = try? regex.wholeMatch(in: data)
            else {
                return nil
            }
            let ax = Int(matches.1)!
            let ay = Int(matches.2)!
            let bx = Int(matches.3)!
            let by = Int(matches.4)!
            let px = Int(matches.5)!
            let py = Int(matches.6)!
            
            aIncrement = GridPoint(x: ax, y: ay)
            bIncrement = GridPoint(x: bx, y: by)
            prize = GridPoint(x: px, y: py)
        }
        
        var buttonMatrix: Matrix<Double> {
            return Matrix([
                [Double(aIncrement.x), Double(bIncrement.x)],
                [Double(aIncrement.y), Double(bIncrement.y)]
            ])
        }
        
        var aColumn: Matrix<Double> {
            Matrix(column: [Double(aIncrement.x), Double(aIncrement.y)])
        }
        
        var bColumn: Matrix<Double> {
            Matrix(column: [Double(bIncrement.x), Double(bIncrement.y)])
        }
        
        var prizeColumn: Matrix<Double> {
            Matrix(column: [Double(prize.x), Double(prize.y)])
        }
        
        var tokenMatrix: Matrix<Double> {
            Matrix(row: [3, 1])
        }
        
        func buttonsToSolve() -> (a: Int, b: Int)? {
            let determinant = det(buttonMatrix)
            debug("  Determinant: \(determinant ?? 0)")
            if abs(determinant ?? 0) < 1 {
                // Both vectors are aligned. Is the prize on the same line?
                return linearlyDependentSolution()
            }
            else {
                return linearlyIndependentSolution()
            }
        }
        
        func linearlyDependentSolution() -> (a: Int, b: Int)? {
            func vectorsAreAligned(_ v: Vector<Double>, _ u: Vector<Double>) -> Bool {
                let multiples = eldiv(v, u)
                return multiples.allSatisfy({ $0 == multiples[0] })
            }
            
            let aVector = buttonMatrix.columnVectors[0]
            let prizeVector = prizeColumn.columnVectors[0]
            
            let aAligned = vectorsAreAligned(aVector, prizeVector)
            
            if !aAligned  {
                // The two vectors are aligned or we wouldn't be in this
                // function, and neither of them point to the prize.
                // There's no way to get there.
                return nil
            }
            
            // Since the vectors are aligned, we can just use the
            // x values of the vectors.
            let a = aIncrement.x
            let b = bIncrement.x
            let p = prize.x
            
            // If there is a solution, it is of the form:
            // ax + by = p, where x and y are integers.
            //
            // And there is a only a solution if 'p' is a multiple of
            // gcd(a, b) = g. So...
            //
            // ax + by = g
            // a(mx) + b(my) = (mg) = p
            //
            // And we can compute those using the extended GCD
            let (g, x, y) = egcd(a, b)
            let m = p / g
            
            // However, this algorithm might compute negative integers.
            // It is actually true that there are recurring patterns
            // of these solutions, at:
            //    mx + (b/g)k
            //    my - (a/g)k
            // so we need to find a value for k that minimizes cost.
            //
            // The minimum value is one that will make `mx+(b/g)k` positive.
            //   mx + (b/g)k ≥ 0
            //   (b/g)k ≥ -mx
            //   k ≥ -mx / (b/g)
            //
            //   (11)(-1) + (3)(1)k ≥ 0
            //   -11 + 3k ≥ 0
            //   3k ≥ 11
            //   k ≥ 11/3
            //
            let minK = Int((-Double(m * x) / Double(b / g)).rounded(.up))
            
            // The maximum value is the one that will keep `my-(a/g)k` positive
            //   my - (a/g)k ≥ 0
            //   -(a/g)k ≥ -my
            //   (a/g)k ≤ my
            //   k ≤ my / (a/g)
            let maxK = Int((Double(m * y) / Double(a / g)).rounded(.down))
            
            let (aCost, bCost) = (3, 1)
            let k: Int
            if (aCost * y) > (bCost * x) {
                k = minK
            }
            else {
                k = maxK
            }
            
            if maxK < minK {
                return nil
            }
            
            let finalA = m*x + (b/g)*k
            let finalB = m*y - (a/g)*k
            
            assert(finalA >= 0 && finalB >= 0)
            
            return (a: finalA, b: finalB)
        }
        
        func linearlyIndependentSolution() -> (a: Int, b: Int)? {
            let buttonCounts = inv(buttonMatrix) * prizeColumn
            let (a, b) = buttonCounts[column: 0].explode()!
            
            if a < 0 || b < 0 {
                debug("  Negative presses required")
                return nil
            }
            
            let roundedA = a.rounded()
            let roundedB = b.rounded()
            let pressesMatrix = Matrix(column: [roundedA, roundedB])
            
            if buttonMatrix * pressesMatrix != prizeColumn {
                debug("  Fractional presses required")
                return nil
            }
            
            return (Int(roundedA), Int(roundedB))
        }
    }
}

private extension Matrix {
    var columnVectors: [Vector<Scalar>] {
        (0..<self.columns).map { Vector(self[column: $0]) }
    }
}

