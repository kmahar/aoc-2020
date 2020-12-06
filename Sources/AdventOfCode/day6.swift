func day6() throws {
    let inputs = try readLines(forDay: 6, omittingEmptySubsequences: false)
    let groups = inputs.split(separator: "")

    var total1 = 0
    var total2 = 0
    for group in groups {
        // merge all of the responses together, and then use a set to de-duplicate questions.
        // the size of the set gives the count for the group.
        let combined = group.reduce("", +)
        let questionSet = Set(combined)
        total1 += questionSet.count

        // convert each person's response to a set, and then find the intersection of all of the
        // sets. the size of the final set gives the count for the group.
        let sets = group.map { Set($0) }
        let intersection = sets[1...].reduce(sets[0]) { $0.intersection($1) }
        total2 += intersection.count
    }

    print("Part 1: \(total1)")
    print("Part 2: \(total2)")
}
