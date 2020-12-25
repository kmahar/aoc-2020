struct Point2D: Hashable {
    let x: Int
    let y: Int
}

struct TilePlacement {
    let x: Int
    let y: Int
    let tile: Tile
}

struct Tile: Hashable {
    let data: [[Character]]

    var topEdge: [Character] { data.first! }
    var leftEdge: [Character] { data.map { $0.first! } }
    var rightEdge: [Character] { data.map { $0.last! } }
    var bottomEdge: [Character] { data.last! }

    var borders: [[Character]] { [topEdge, leftEdge, rightEdge, bottomEdge] }

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

    func flipped() -> Tile {
        Tile(data: data.map { $0.reversed() })
    }

    func rotated() -> Tile {
        var output = [[Character]]()
        for i in 0 ..< data.first!.count {
            let data = self.data.map { $0[i] }
            output.append(data.reversed())
        }
        return Tile(data: output)
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
        var matchingIds = [Int]()
        for (id2, tile2) in tiles where id1 != id2 {
            if tile1.hasMatchingBorder(with: tile2) {
                matchingIds.append(id2)
            }
        }
        if matchingIds.count == 2 {
            corners.append(id1)
        }
    }

    print("Part 1: \(corners.reduce(1, *))")

    // tiles to placement locations
    var tilesToPlacements = [Int: TilePlacement]()
    let (firstId, firstTile) = tiles.first!
    // place the first tile at (0,0) and use it as a basis for placing all other tiles.
    tilesToPlacements[firstId] = TilePlacement(x: 0, y: 0, tile: firstTile)

    // points to tile IDs
    var pointsToTiles = [Point2D: Int]()
    pointsToTiles[Point2D(x: 0, y: 0)] = firstId
    var tilesToProcess = [firstId]

    // tiles we'e already found neighbors for
    var processedIds = Set<Int>()

    // save permutations for efficiency.
    var computedPermutations = [Int: [Tile]]()

    while tilesToPlacements.count < tiles.count, !tilesToProcess.isEmpty {
        var processNext = [Int]()
        for id in tilesToProcess {
            processedIds.insert(id) // don't revisit this ID, we've already found its neighbors.
            let placementData = tilesToPlacements[id]!
            for (otherId, otherData) in tiles where !processedIds.contains(otherId) {
                let permutations: [Tile]
                if let perms = computedPermutations[otherId] {
                    permutations = perms
                } else {
                    let r1 = otherData.rotated()
                    let r2 = r1.rotated()
                    let r3 = r2.rotated()
                    permutations = [
                        otherData,
                        r1,
                        r2,
                        r3,
                        otherData.flipped(),
                        r1.flipped(),
                        r2.flipped(),
                        r3.flipped(),
                    ]
                    computedPermutations[otherId] = permutations
                }

                for perm in permutations {
                    let newPlacement: TilePlacement!

                    if placementData.tile.rightEdge == perm.leftEdge {
                        newPlacement = TilePlacement(x: placementData.x + 1, y: placementData.y, tile: perm)
                    } else if placementData.tile.bottomEdge == perm.topEdge {
                        newPlacement = TilePlacement(x: placementData.x, y: placementData.y - 1, tile: perm)
                    } else if placementData.tile.leftEdge == perm.rightEdge {
                        newPlacement = TilePlacement(x: placementData.x - 1, y: placementData.y, tile: perm)
                    } else if placementData.tile.topEdge == perm.bottomEdge {
                        newPlacement = TilePlacement(x: placementData.x, y: placementData.y + 1, tile: perm)
                    } else {
                        continue
                    }
                    tilesToPlacements[otherId] = newPlacement
                    pointsToTiles[Point2D(x: newPlacement.x, y: newPlacement.y)] = otherId
                    processNext.append(otherId)
                    break
                }
            }
        }
        tilesToProcess = processNext
    }

    let xValues = Set(pointsToTiles.keys.map { $0.x })
    let yValues = Set(pointsToTiles.keys.map { $0.y })
    var arrangedData = [[Character]]()

    for y in yValues.sorted().reversed() {
        var data: [[Character]] = (1 ... 8).map { _ in [] }
        for x in xValues.sorted() {
            guard let tileId = pointsToTiles[Point2D(x: x, y: y)] else {
                fatalError("missing tile at \(x), \(y)")
            }
            let tile = tilesToPlacements[tileId]!.tile
            let strippedData = tile.data.dropFirst().dropLast().map { $0.dropFirst().dropLast() }
            for (i, d) in strippedData.enumerated() {
                data[i].append(contentsOf: d)
            }
        }
        arrangedData += data
    }

    let pattern = [
        "                  # ",
        "#    ##    ##    ###",
        " #  #  #  #  #  #   ",
    ]

    var image = arrangedData
    // try all 8 possible orientations of the image
    for iteration in 1 ... 8 {
        let monsterCounts = (0 ... arrangedData.count - 3).map { y in
            (0 ... arrangedData[0].count - pattern[0].count).filter { x in
                (0 ... 2).allSatisfy { row in
                    pattern[row].enumerated().allSatisfy { i, elt in
                        elt == " " || image[y + row][x + i] == "#"
                    }
                }
            }.count
        }

        let seaMonsterCount = monsterCounts.reduce(0, +)

        if seaMonsterCount > 0 {
            let numHashesInSeaMonsters = seaMonsterCount * pattern.reduce("", +).filter { $0 == "#" }.count
            let numHashesTotal = arrangedData.reduce([], +).filter { $0 == "#" }.count
            print("Part 2: \(numHashesTotal - numHashesInSeaMonsters)")
            return
        }

        // flip image halfway through
        if iteration == 4 {
            image = image.map { $0.reversed() }
            // rotate image
        } else {
            var rotated = [[Character]]()

            for i in 0 ..< image.first!.count {
                let data = image.map { $0[i] }
                rotated.append(data.reversed())
            }

            image = rotated
        }
    }

    print("No solution found for part 2")
}
