import Algorithms
import SE0270_RangeSet
import AdventCore
import Foundation

struct Day06: AdventDay {

    var records: [RaceRecord]
    var singleRecord: RaceRecord

    init(data: String) {
        let (line1, line2) = data.lines.explode()!

        let pairs = [line1, line2]
            .map {
                $0.split(separator: " ")
                    .dropFirst()
                    .map { Int($0)! }
            }
        |> { zip($0[0], $0[1]) }

        let records = pairs.map {
            RaceRecord(time: $0.0, recordDistance: $0.1)
        }

        self.records = records

        let (time, distance) = [line1, line2]
            .map { Int($0.split(separator: ":")[1].replacing(" ", with: ""))! }
            .explode()!

        singleRecord = RaceRecord(time: time, recordDistance: distance)
    }

    func part1() -> Int {
        return records
            .map { $0.chargingTimesToBeatRecord()?.count ?? 0 }
            .reduce(1, *)
    }

    func part2() -> Int {
        singleRecord.chargingTimesToBeatRecord()?.count ?? 0
    }
}


extension Day06 {
    struct RaceRecord {
        var time: Int
        var recordDistance: Int

        func chargingTimesToBeatRecord() -> ClosedRange<Int>? {
            let a = Double(-1)
            let b = Double(time)
            let c = Double(-recordDistance)-0.01

            if let (a1, a2) = quadratic(a:a, b:b, c:c) {
                let min = Int(ceil(a1))
                let max = Int(floor(a2))
                return min...max
            }
            return nil
        }

    }

    func distance(totalTime: Int, chargeTime: Int) -> Int {
        (totalTime - chargeTime) * chargeTime

        // - chargeTime^2 + (totalTime * chargeTime)
    }


}

private func quadratic(a: Double, b: Double, c: Double) -> (Double, Double)? {
    let discriminant = b*b - 4*a*c
    if discriminant < 0 { return nil }

    let sDim = sqrt(discriminant)

    let r1 = (-b - sDim) / (2*a)
    let r2 = (-b + sDim) / (2*a)

    return [r1, r2].sorted().explode()
}

