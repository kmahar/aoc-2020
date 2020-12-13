enum State: Character {
    case floor = "."
    case empty = "L"
    case occupied = "#"
}

/// Runs the provided input until it reaches equilibrium and none of the seats are changing anymore.
/// - Parameters:
///   - rows: The input data
///   - switchToEmptyThreshold: the threshold of surrounding seats being occupied at which at seat will
///                             switch to being empty on the next iteration
///   - getConsideredCells: a function, which given (x, y, currentState) returns a list of the seats which
//                          will be factored in when next determining the state of the seat at (x, y)
/// - Returns: a count of the occupied seats in the equilibrium state.
func runUntilEquilibrium(
    _ rows: [[State]],
    switchToEmptyThreshold: Int,
    getConsideredSeats: (Int, Int, [[State]]) -> [(Int, Int)]
) -> Int {
    let xMax = rows[0].count
    let yMax = rows.count

    var current = rows
    var modifiedCount = -1

    while modifiedCount != 0 {
        modifiedCount = 0
        var copy = current

        for x in 0 ..< xMax {
            for y in 0 ..< yMax {
                let currentState = current[y][x]
                // floor seats never change
                guard currentState != .floor else {
                    continue
                }

                let occupiedCount = getConsideredSeats(x, y, current)
                    .map { i, j in
                        current[j][i] == .occupied ? 1 : 0
                    }.reduce(0, +)

                // if a seat is empty and there are no occupied seats adjacent to it, the seat becomes occupied
                if currentState == .empty, occupiedCount == 0 {
                    modifiedCount += 1
                    copy[y][x] = .occupied
                } else if currentState == .occupied, occupiedCount >= switchToEmptyThreshold {
                    modifiedCount += 1
                    copy[y][x] = .empty
                }
            }
        }

        current = copy
    }

    return current.reduce([], +).filter { $0 == .occupied }.count
}

let borderingCells = [
    (-1, -1),
    (-1, 0),
    (-1, 1),
    (0, 1),
    (0, -1),
    (1, -1),
    (1, 0),
    (1, 1),
]

func day11() throws {
    let rows = try readLines(forDay: 11).map { $0.map { State(rawValue: $0)! } }
    let xMax = rows[0].count
    let yMax = rows.count

    let part1Result = runUntilEquilibrium(rows, switchToEmptyThreshold: 4) { x, y, _ in
        borderingCells.map { i, j in
            (x + i, y + j)
        }.filter { i, j in
            (0 ..< xMax).contains(i) && (0 ..< yMax).contains(j)
        }
    }

    print("Part 1: \(part1Result)")

    let part2Result = runUntilEquilibrium(rows, switchToEmptyThreshold: 5) { x, y, current in
        var cells = [(Int, Int)]()

        // find first seat above
        if let firstAbove = stride(from: y - 1, through: 0, by: -1).first(where: { current[$0][x] != .floor }) {
            cells.append((x, firstAbove))
        }

        // find first seat below
        if let firstBelow = stride(from: y + 1, to: yMax, by: 1).first(where: { current[$0][x] != .floor }) {
            cells.append((x, firstBelow))
        }

        if let firstLeft = stride(from: x - 1, through: 0, by: -1).first(where: { current[y][$0] != .floor }) {
            cells.append((firstLeft, y))
        }

        if let firstRight = stride(from: x + 1, to: xMax, by: 1).first(where: { current[y][$0] != .floor }) {
            cells.append((firstRight, y))
        }

        // find first seat up and left
        if let firstUpLeft = zip(stride(from: x - 1, through: 0, by: -1), stride(from: y - 1, through: 0, by: -1))
            .first(where: { current[$1][$0] != .floor })
        {
            cells.append(firstUpLeft)
        }

        // find first seat down and left
        if let firstDownLeft = zip(stride(from: x - 1, through: 0, by: -1), stride(from: y + 1, to: yMax, by: 1))
            .first(where: { current[$1][$0] != .floor })
        {
            cells.append(firstDownLeft)
        }

        // find first seat up and right
        if let firstUpRight = zip(stride(from: x + 1, to: xMax, by: 1), stride(from: y - 1, through: 0, by: -1))
            .first(where: { current[$1][$0] != .floor })
        {
            cells.append(firstUpRight)
        }

        // find first down up and right
        if let firstDownRight = zip(stride(from: x + 1, to: xMax, by: 1), stride(from: y + 1, to: yMax, by: 1))
            .first(where: { current[$1][$0] != .floor })
        {
            cells.append(firstDownRight)
        }

        return cells
    }

    print("Part 2: \(part2Result)")
}
