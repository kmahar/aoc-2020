func findTwoElementsSumming(to value: Int, in input: Set<Int>) -> (Int, Int)? {
    for elt in input {
        let complement = value - elt
        if input.contains(complement) {
            return (elt, complement)
        }
    }
    return nil
}

func day1() throws {
    let inputs = Set(try readLines(forDay: 1).map { Int($0)! })

    guard let (v1, v2) = findTwoElementsSumming(to: 2020, in: inputs) else {
        print("No solution found for Part 1")
        return
    }
    print("Part 1: \(v1 * v2)")

    for elt in inputs {
        let complement = 2020 - elt
        if let (v3, v4) = findTwoElementsSumming(to: complement, in: inputs) {
            print("Part 2: \(elt * v3 * v4)")
            return
        }
    }
    print("No solution found for Part 2")
}
