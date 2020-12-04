func day2() throws {
    let inputs = try readLines(forDay: 2)
    var valid1 = 0
    var valid2 = 0
    for inp in inputs {
        let components = inp.split(separator: " ")

        // format is:
        // v1-v2 letter: password

        let counts = components[0].split(separator: "-")
        let v1 = Int(counts[0])!
        let v2 = Int(counts[1])!

        let letter = components[1].first! // drop the :
        let password = components[2]

        let chars = Array(password)

        // pt 1 rules
        let occurrences = password.filter { $0 == letter }.count
        if (v1 ... v2).contains(occurrences) {
            valid1 += 1
        }

        // pt 2 rules
        if (chars[v1 - 1] == letter) != (chars[v2 - 1] == letter) {
            valid2 += 1
        }
    }

    print("Part 1: \(valid1)")
    print("Part 2: \(valid2)")
}
