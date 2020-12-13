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

    // it would be nice to use an (Int, Int) here but that type is not hashable
    var sums = [[Int]: Int]()

    for i in 0 ..< inputs.count - 1 {
        for j in i ..< inputs.count {
            let sum = i == j ? inputs[i] : sums[[i, j - 1]]! + inputs[j]

            // we found an answer
            if i != j, sum == part1 {
                let range = inputs[i ... j]
                let min = range.min()!
                let max = range.max()!
                print("Part 2: \(min + max)")
                return
            }

            // [i...j] already exceeds the target value. since all values are positive,
            // any sequence starting at i and ending after j will also be too large,
            // so no point in continuing to fill out this data.
            else if sum > part1 {
                break
            }

            sums[[i, j]] = sum
        }
    }
}
