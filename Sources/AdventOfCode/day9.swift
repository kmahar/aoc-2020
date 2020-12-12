extension Set where Element == Int {
    func containsTwoElementsSumming(to value: Int) -> Bool {
        for elt in self {
            let complement = value - elt
            if contains(complement) {
                return true
            }
        }
        return false
    }
}

func day9() throws {
    var part1: Int!

    let inputs = try readLines(forDay: 9).map { Int($0)! }
    for i in 25 ..< inputs.count {
        let prev25 = Set(inputs[(i - 25) ..< i])
        guard prev25.containsTwoElementsSumming(to: inputs[i]) else {
            part1 = inputs[i]
            break
        }
    }

    print("Part 1: \(part1!)")

    // this is a (close to) brute force solution trying out every subsequence of length 2+.
    for i in 0 ..< inputs.count - 1 {
        for j in (i + 1) ..< inputs.count {
            let subrange = inputs[i ... j]
            let sum = subrange.reduce(0, +)
            // [i...j] already exceeds the target value. since all values are positive,
            // any sequence starting at i and ending after j will also be too large.
            if sum > part1 {
                break
            }
            if sum == part1 {
                let part2Min = subrange.min()!
                let part2Max = subrange.max()!
                print("Part 2: \(part2Min + part2Max)")
                return
            }
        }
    }
}
