func partition(min: Int, max: Int, input: Substring, first: Character) -> Int {
    var min = Double(min)
    var max = Double(max)
    for char in input {
        let midPoint = min + (max - min) / 2
        if char == first {
            max = midPoint
            max.round(.down)
        } else {
            min = midPoint
            min.round(.up)
        }
    }
    return Int(min)
}

struct Seat {
    let row: Int
    let col: Int

    var id: Int {
        row * 8 + col
    }
}

func day5() throws {
    let lines = try readLines(forDay: 5)

    var seats = [Seat]()

    for line in lines {
        let row = partition(min: 0, max: 127, input: line.prefix(7), first: "F")
        let col = partition(min: 0, max: 7, input: line.suffix(3), first: "L")
        seats.append(Seat(row: row, col: col))
    }

    let maxSeatId = seats.max { $0.id < $1.id }!.id
    print("Part 1: \(maxSeatId)")

    // sort by row and then column
    seats.sort { s1, s2 in
        guard s1.row != s2.row else {
            return s1.col < s2.col
        }
        return s1.row < s2.row
    }

    let lowestSeat = seats.first!
    var lastRow = lowestSeat.row
    var lastCol = lowestSeat.col

    var missingRow: Int!
    var missingCol: Int!

    for seat in seats[1...] {
        // we haven't changed rows
        if seat.row == lastRow {
            // we should have only moved over one seat.
            guard seat.col == lastCol + 1 else {
                missingRow = lastRow
                missingCol = lastCol + 1
                break
            }
            lastCol = seat.col
            continue
        } else {
            // we did change rows; ensure we saw the last seat in the last row.
            // if not, that is missing one.
            guard lastCol == 7 else {
                missingRow = lastRow
                missingCol = 7
                break
            }

            // we are at the start of a new row; ensure it's seat 0.
            guard seat.col == 0 else {
                missingRow = seat.row
                missingCol = 0
                break
            }
        }

        lastRow = seat.row
        lastCol = seat.col
    }

    print("Part 2: \(missingRow * 8 + missingCol)")
}
