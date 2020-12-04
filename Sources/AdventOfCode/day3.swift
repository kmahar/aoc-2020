func countTrees(map: [[Character]], xChange: Int, yChange: Int) -> Int {
    // exclusive bounds for max x and y values. treat y as
    // increasing as we go down
    let xMax = map[0].count
    let yMax = map.count

    var currX = 0
    var currY = 0
    var treesSeen = 0

    while currY < yMax {
        if map[currY][currX] == "#" {
            treesSeen += 1
        }

        currX += xChange
        currX = currX % xMax // account for repeating pattern
        currY += yChange
    }

    return treesSeen
}

func day3() throws {
    let inputs = try readLines(forDay: 3).map { Array($0) }

    let part1 = countTrees(map: inputs, xChange: 3, yChange: 1)
    print("Part 1: \(part1)")

    let part2 = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
        .map { countTrees(map: inputs, xChange: $0.0, yChange: $0.1) }
        .reduce(1, *)

    print("Part 2: \(part2)")
}
