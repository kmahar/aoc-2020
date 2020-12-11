func day7() throws {
    let lines = try readLines(forDay: 7)

    // build a map of [color: colors than can contain it]
    var pt1Map = [String: Set<String>]()

    // build a map of [color: [(count, color) for colors the bag contains]]
    var pt2Map = [String: [(Int, String)]]()

    for line in lines {
        let split = line.components(separatedBy: " bags contain ")
        let containingColor = split[0]
        pt2Map[containingColor] = []
        let contents = split[1].dropLast().components(separatedBy: ", ")
        for content in contents {
            guard content != "no other bags" else {
                break
            }
            let parts = content.split(separator: " ")
            let count = Int(parts[0])!
            let color = parts.dropFirst().dropLast().joined(separator: " ")

            pt1Map[color] = pt1Map[color, default: []]
            pt1Map[color]!.insert(containingColor)

            pt2Map[containingColor]!.append((count, color))
        }
    }

    // think of pt1Map as containing edges in a directed graph, where each (k, v) pair is (parent, [child]).
    // do a breadth first traversal starting at "shiny gold" and keep track of all the nodes we visit.
    var toConsider = Array(pt1Map["shiny gold"]!)
    var topLevelBags = Set<String>()

    while !toConsider.isEmpty {
        // children to consider on the next iteration.
        var considerNext = [String]()

        for color in toConsider {
            if !topLevelBags.contains(color) {
                if let canBeContainedBy = pt1Map[color] {
                    considerNext += Array(canBeContainedBy)
                }
                topLevelBags.insert(color)
            }
        }

        toConsider = considerNext
    }

    print("Part 1: \(topLevelBags.count)")

    let part2 = countBags(for: "shiny gold", data: pt2Map)
    print("Part 2: \(part2)")
}

/// Counts how many bags are contained by the bag with color `color`.
func countBags(for color: String, data: [String: [(Int, String)]]) -> Int {
    let targetContents = data[color]!
    return targetContents.map { count, color in
        count * (1 + countBags(for: color, data: data))
    }.reduce(0, +)
}
