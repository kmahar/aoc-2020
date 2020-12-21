func run(startSequence: [Int], iterations: Int) -> Int {
    // map of numbers said to the last 1 or 2 turns they were spoken on.
    var seenNumbers = [Int: [Int]]()
    for (i, num) in startSequence.enumerated() {
        seenNumbers[num] = [i]
    }

    var lastNumber = startSequence.last!

    for i in seenNumbers.count ..< iterations {
        if let spokenTurns = seenNumbers[lastNumber], spokenTurns.count == 2 {
            let difference = spokenTurns.last! - spokenTurns.first!
            lastNumber = difference
        } else {
            lastNumber = 0
        }
        seenNumbers[lastNumber] = (seenNumbers[lastNumber, default: []] + [i]).suffix(2)
    }

    return lastNumber
}

func day15() throws {
    let input = try readLines(forDay: 15)[0].split(separator: ",").map { Int($0)! }
    print("Part 1: \(run(startSequence: input, iterations: 2020))")
    print("Part 2: \(run(startSequence: input, iterations: 30_000_000))")
}
