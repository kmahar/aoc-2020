struct Point3D: Point {
    let x: Int
    let y: Int
    let z: Int

    var neighboringPoints: [Point3D] {
        var output = [Point3D]()
        for x in (x - 1) ... (x + 1) {
            for y in (y - 1) ... (y + 1) {
                for z in (z - 1) ... (z + 1) {
                    // don't include self.
                    if x == self.x, y == self.y, z == self.z { continue }
                    output.append(Point3D(x: x, y: y, z: z))
                }
            }
        }
        return output
    }
}

struct Point4D: Point {
    let x: Int
    let y: Int
    let z: Int
    let w: Int

    var neighboringPoints: [Point4D] {
        var output = [Point4D]()
        for x in (x - 1) ... (x + 1) {
            for y in (y - 1) ... (y + 1) {
                for z in (z - 1) ... (z + 1) {
                    for w in (w - 1) ... (w + 1) {
                        // don't include self.
                        if x == self.x, y == self.y, z == self.z, w == self.w { continue }
                        output.append(Point4D(x: x, y: y, z: z, w: w))
                    }
                }
            }
        }
        return output
    }
}

protocol Point: Hashable {
    var neighboringPoints: [Self] { get }
}

func runSimulation<T: Point>(initialState: [T: Bool]) -> [T: Bool] {
    var state = initialState

    for _ in 1 ... 6 {
        // we need to consider all the points we currently are tracking as well as all of their neighbors
        // when figuring out which points could have possibly changed state.
        let pointsToConsider = Set(
            state.keys +
                state.keys.map { $0.neighboringPoints }.reduce([], +)
        )

        var updatedState = state

        for pt in pointsToConsider {
            let isActive = state[pt] ?? false
            let activeNeighbors = pt.neighboringPoints.compactMap { state[$0] }.filter { $0 }.count
            if isActive, ![2, 3].contains(activeNeighbors) {
                updatedState[pt] = false
            } else if !isActive, activeNeighbors == 3 {
                updatedState[pt] = true
            }
        }
        state = updatedState
    }

    return state
}

func day17() throws {
    let input = try readLines(forDay: 17).map { Array($0).map { $0 == "#" ? true : false } }

    var state1 = [Point3D: Bool]()
    var state2 = [Point4D: Bool]()

    for y in 0 ..< input.count {
        for x in 0 ..< input[0].count {
            let pt = Point3D(x: x, y: y, z: 0)
            state1[pt] = input[y][x]

            let pt2 = Point4D(x: x, y: y, z: 0, w: 0)
            state2[pt2] = input[y][x]
        }
    }

    let part1FinalState = runSimulation(initialState: state1)
    let activeCount1 = part1FinalState.filter { $0.1 }.count
    print("Part 1: \(activeCount1)")

    let part2FinalState = runSimulation(initialState: state2)
    let activeCount2 = part2FinalState.filter { $0.1 }.count
    print("Part 2: \(activeCount2)")
}
