extension ClosedRange where Bound == Int {
    /// Initialize from a string of the form start-end.
    init(_ s: String) {
        let components = s.split(separator: "-")
        let low = Int(components[0])!
        let high = Int(components[1])!
        self = low ... high
    }
}

/// Represents a description of a ticket field.
struct Field {
    /// Field name.
    let name: String
    /// First valid range for field values.
    let range1: ClosedRange<Int>
    /// Second valid range for field values.
    let range2: ClosedRange<Int>

    init(_ s: Substring) {
        let components = s.components(separatedBy: ": ")
        name = components[0]
        let ranges = components[1].components(separatedBy: " or ")
        range1 = ClosedRange(ranges[0])
        range2 = ClosedRange(ranges[1])
    }

    /// Returns a boolean indicating whether the provided value is within one of the valid ranges for this field.
    func isSatisfied(by value: Int) -> Bool {
        range1.contains(value) || range2.contains(value)
    }
}

func day16() throws {
    let input = try readLines(forDay: 16, omittingEmptySubsequences: false)
    let components = input.split(separator: "")

    let rules = components[0].map { Field($0) }
    let myTicketData = components[1].last!.split(separator: ",").map { Int($0)! }
    let nearbyTickets = components[2].dropFirst().map { $0.split(separator: ",").map { Int($0)! } }

    let errorRate = nearbyTickets.map { ticketData in
        ticketData.map { value in
            rules.contains { $0.isSatisfied(by: value) } ? 0 : value
        }.reduce(0, +)
    }.reduce(0, +)

    print("Part 1: \(errorRate)")

    let validTickets = nearbyTickets.filter { ticketData in
        ticketData.allSatisfy { value in
            rules.contains { $0.isSatisfied(by: value) }
        }
    }

    // build up an array of possible field names for the values at each index.
    var possibleFieldsByIndex = [Set<String>]()
    for i in 0 ..< validTickets[0].count {
        possibleFieldsByIndex.append(
            Set(
                rules.filter { rule in
                    validTickets.map { $0[i] }.allSatisfy { value in rule.isSatisfied(by: value) }
                }.map { $0.name }
            )
        )
    }

    // map of index to field name. we use a map because we are not going to be able to determine the names in order,
    // e.g. we may figure out the name for field 3 before field 0, 1, or 2, etc.
    var positionsToNames = [Int: String]()

    // there are multiple valid field names for a number of positions. we assign names to each position by repeatedly
    // looking for the most constrained position, i.e. a position where there is only one valid name left, assigning
    // it that name, and then removing that name from the options for all other positions. we repeatedly loop until
    // we've finished.
    while positionsToNames.count < possibleFieldsByIndex.count {
        for (i, fieldNames) in possibleFieldsByIndex.enumerated() where fieldNames.count == 1 {
            let fieldName = Array(fieldNames)[0]
            positionsToNames[i] = fieldName
            // remove this name from the possible names for all indexes.
            for i in 0 ..< possibleFieldsByIndex.count {
                possibleFieldsByIndex[i].remove(fieldName)
            }
        }
    }

    // convert map of (index, value) to array.
    let sortedFieldNames = positionsToNames.sorted { $0.0 < $1.0 }.map { $0.1 }

    // find the indexes that correspond to "departure" fields, retrieve their values from my ticket, and multiply.
    let pt2 = sortedFieldNames.enumerated().filter { _, fieldName in
        fieldName.starts(with: "departure")
    }.map { i, _ in
        myTicketData[i]
    }.reduce(1, *)

    print("Part 2: \(pt2)")
}
