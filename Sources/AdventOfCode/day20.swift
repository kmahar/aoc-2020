struct Tile: Hashable {
    let data: [[Character]]

    var borders: [[Character]] {
        [
            data.first!,
            data.last!,
            data.map { $0.first! },
            data.map { $0.last! },
        ]
    }

    func hasMatchingBorder(with other: Tile) -> Bool {
        for b1 in borders {
            for b2 in other.borders {
                if b1 == b2 || b1.reversed() == b2 {
                    return true
                }
            }
        }
        return false
    }
}

func day20() throws {
    let input = try readLines(forDay: 20, omittingEmptySubsequences: false)
    let tileData = input.split(separator: "")

    var tiles = [Int: Tile]()
    for data in tileData {
        let idLine = data.first!
        let id = Int(idLine.split(separator: " ")[1].dropLast())!
        let dataLines = data.dropFirst().map { Array($0) }
        tiles[id] = Tile(data: dataLines)
    }

    var corners = [Int]()
    for (id1, tile1) in tiles {
        var matchingCount = 0
        for (id2, tile2) in tiles where id1 != id2 {
            if tile1.hasMatchingBorder(with: tile2) {
                matchingCount += 1
            }
        }
        if matchingCount == 2 {
            corners.append(id1)
        }
    }

    print("Part 1: \(corners.reduce(1, *))")

    // TODO: part 2
}
