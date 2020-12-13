func day10() throws {
    let inputs = try readLines(forDay: 10).map { Int($0)! }.sorted()

    // part 1
    let sortedAdapters = [0] + inputs + [inputs.last! + 3]
    var oneVoltDiffs = 0
    var threeVoltDiffs = 0
    for i in 0 ..< (sortedAdapters.count - 1) {
        let difference = sortedAdapters[i + 1] - sortedAdapters[i]
        if difference == 1 {
            oneVoltDiffs += 1
        } else if difference == 3 {
            threeVoltDiffs += 1
        }
    }

    print("Part 1: \(oneVoltDiffs * threeVoltDiffs)")

    // for each index, store the number of ways to get from the charging outlet to the
    // to the adapter at that index.
    var solutions = [Int]()
    // only one way to get from the outlet to itself!
    solutions.append(1)

    for i in 1 ..< sortedAdapters.count {
        // set initial value to 0.
        solutions.append(0)
        //  we only need to consider at most 3 indexes back, because a value 4+ indexes
        // earlier would have a joltage difference of > 3.
        for prevIdx in i - 3 ..< i where prevIdx >= 0 {
            // if the difference is less than 3, we can get to adapter i from adapter
            // prevIdx. therefore, any route from the outlet to adapter prevIdx is also
            // a valid path to adapter i.
            if sortedAdapters[i] - sortedAdapters[prevIdx] <= 3 {
                solutions[i] += solutions[prevIdx]
            }
        }
    }

    // the last adapter is actually the device.
    print("Part 2: \(solutions.last!)")
}
