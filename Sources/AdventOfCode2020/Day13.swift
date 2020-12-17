//
//  Day15.swift
//  
//
//  Created by BJ Homer on 12/5/20.
//

import Foundation
import AdventCore
import Algorithms

func day13(input: Data) {
    let inputString = String(decoding: input, as: UTF8.self)

//    let exampleString = """
//    939
//    3,5,4
//    """

    let lines = inputString
        .split(separator: "\n")

    let line1 = lines[0]
    let line2 = lines[1]

    let earliestTime = Int(line1)!
    let busIDs = line2.split(separator: ",").compactMap { Int($0) }

    let part1 = earliestBus(from: busIDs, after: earliestTime)
    print("Part 1: \(part1) -> \(part1.bus * part1.wait)")


    let busSightings = line2.split(separator: ",").map { Int($0) }
    let busSchedule = BusSchedule(busSightings)

    let finalRecurrence = Recurrence.jointRecurrence(busSchedule.recurrences)
    print("Part 2: \(finalRecurrence.periodStartTime)")

}

// Part 1
private func earliestBus(from buses: [Int], after earliestTime: Int) -> (bus: Int, wait: Int) {
    for time in (earliestTime...) {
        for bus in buses {
            if time.isMultiple(of: bus) { return (bus: bus, wait: time - earliestTime) }
        }
    }
    fatalError("Never found a match")
}


/*
 -- Part 2 --

 7,13,x,x,59,x,31,19

 t     % 7  == 0
 (t+1) % 13 == 0
 (t+4) % 59 == 0
 (t+6) % 31 == 0
 (t+7) % 19 == 0

 What is the lowest possible value of t?

 We know t+7 must be a multiple of both 7 and 19, which means it's
 a multiple of the least-common-multiple (lcm) of 7 and 19, which
 is 133.

 It would be nice if we could see when any particular pair of buses
 would coincide. For example, when will 7 and 13 coincide? We know
 this coincidence will have a period of lcm(7,13) = 91 minutes, and
 somewhere in that window is a moment when both 't % 7 == 0' and
 '(t+1) % 13 == 0' are true. We can use the larger of the two numbers
 to skip through the window looking for times that satisfy this
 constraint.

 Can we do better? Can we find when any particular _trio_ of buses
 will coincide? By definition, it must be time when any two of the
 buses were satisfy the constraints, so we can start by finding the
 recurrence period of the first two, and then treat that as a new
 imaginary bus with its own recurrence schedule. Then we're back to
 just merging two. This scales indefinitely!
 */

/// Represents a recurring event that occurs relative to a time 't', satisfying
/// `(t+offset) % period == 0`. 
private struct Recurrence {
    var period: Int
    var offset: Int

    var periodStartTime: Int {
        let positiveOffset = (offset).positiveMod(period)
        return period - positiveOffset
    }

    func occurs(at time: Int) -> Bool {
        return (time + offset).positiveMod(period) == 0
    }

    /// Given two recurrences "a" and "b", they will form a repeating pattern
    /// which has its *own* period. At some time 't' within that pattern, they will occur
    /// at (t + a.offset, t + b.offset).
    ///
    /// The return value has the period of their joint repeating pattern, and the
    /// offset indicates where in that joint period that event happened. The result
    ///
    static func jointRecurrence(_ a: Recurrence, _ b: Recurrence) -> Recurrence {
        let jointPeriod = lcm(a.period, b.period)
        let longerRecurrence = [a, b].max(by: { $0.period < $1.period })!
        let stridePeriod = longerRecurrence.period
        let strideOffset = longerRecurrence.offset


        let occurrenceTime = stride(from: 0, through: jointPeriod, by: stridePeriod)
            .first(where: { (time) in
                    let baseTime = time - strideOffset
                    return a.occurs(at: baseTime) && b.occurs(at: baseTime) }
            )!
            // We're taking steps via the larger stride, but the times we need to evaluate
            // need to be adjusted by the offset of this larger stride.
            // For example, if we know (t+2) % 15 == 0, we'll step through in steps of 15,
            // but when we find an actual time, it needs to be shifted back by 2
            - longerRecurrence.offset


        // If the event happened at time 45 with a period of 55, then that means
        // that (t-45) % 55 == 0. We'd prefer to have a positive offset, though,
        // so we return (t+10) % 55 == 0, which is equivalent.
        let jointOffset = (-occurrenceTime).positiveMod(jointPeriod)
        return Recurrence(period: jointPeriod, offset: jointOffset)
    }

    static func jointRecurrence(_ recurrences: [Recurrence]) -> Recurrence {
        guard var result = recurrences.first else { return Recurrence(period: 1, offset: 0) }
        for recurrence in recurrences.dropFirst() {
            result = Recurrence.jointRecurrence(result, recurrence)
        }
        return result
    }
}

private struct BusSchedule {
    var recurrences: [Recurrence]

    init(_ buses: [Int?]) {
        recurrences = buses
            .indexed()
            .compactMap { (tuple) -> Recurrence? in
                let (index, optBusID) = tuple
                guard let busID = optBusID else { return nil }
                return Recurrence(period: busID, offset: index)
            }
    }


}

