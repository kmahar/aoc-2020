enum Rotation {
    case ninety
    case oneEighty
    case twoSeventy

    init(_ value: Int) {
        switch value {
        case 90, -270:
            self = .ninety
        case 180, -180:
            self = .oneEighty
        case 270, -90:
            self = .twoSeventy
        default:
            fatalError("Unsupported rotation angle \(value)")
        }
    }
}

enum Action {
    /// Move north by the given value.
    case north(Int)
    /// Move south by the given value.
    case south(Int)
    /// Move east by the given value.
    case east(Int)
    /// Move west by the given value.
    case west(Int)
    /// Rotate the given number of degrees counterclockwise.
    case rotate(Rotation)
    /// Move forward by the given value in the direction the ship is currently facing.
    case forward(Int)

    init(_ value: Substring) {
        let char = value.first!
        let value = Int(value.dropFirst())!
        switch char {
        case "N":
            self = .north(value)
        case "S":
            self = .south(value)
        case "E":
            self = .east(value)
        case "W":
            self = .west(value)
        case "L":
            self = .rotate(Rotation(value))
        case "R":
            self = .rotate(Rotation(-1 * value))
        case "F":
            self = .forward(value)
        default:
            fatalError("Unrecognized action \(value)")
        }
    }
}

enum Direction {
    case north, south, east, west
}

func part1(_ input: [Action]) -> Int {
    var direction: Direction = .east
    var x = 0
    var y = 0

    for step in input {
        switch step {
        case let .north(dist):
            y += dist
        case let .south(dist):
            y -= dist
        case let .east(dist):
            x += dist
        case let .west(dist):
            x -= dist
        case let .rotate(rotation):
            switch (direction, rotation) {
            case (.west, .twoSeventy), (.east, .ninety), (.south, .oneEighty):
                direction = .north
            case (.north, .ninety), (.east, .oneEighty), (.south, .twoSeventy):
                direction = .west
            case (.west, .ninety), (.east, .twoSeventy), (.north, .oneEighty):
                direction = .south
            case (.west, .oneEighty), (.north, .twoSeventy), (.south, .ninety):
                direction = .east
            }
        case let .forward(dist):
            switch direction {
            case .east:
                x += dist
            case .north:
                y += dist
            case .west:
                x -= dist
            case .south:
                y -= dist
            }
        }
    }

    return abs(x) + abs(y)
}

func part2(_ input: [Action]) -> Int {
    var x = 0
    var y = 0

    // relative position to ship
    var wpX = 10
    var wpY = 1

    for step in input {
        switch step {
        case let .north(dist):
            wpY += dist
        case let .south(dist):
            wpY -= dist
        case let .east(dist):
            wpX += dist
        case let .west(dist):
            wpX -= dist
        case let .rotate(rotation):
            switch rotation {
            case .oneEighty:
                wpX *= -1
                wpY *= -1
            case .ninety:
                let oldX = wpX
                wpX = -1 * wpY
                wpY = oldX
            case .twoSeventy:
                let oldX = wpX
                wpX = wpY
                wpY = -1 * oldX
            }
        case let .forward(dist):
            x += wpX * dist
            y += wpY * dist
        }
    }

    return abs(x) + abs(y)
}

func day12() throws {
    let input = try readLines(forDay: 12).map { Action($0) }
    print("Part 1: \(part1(input))")
    print("Part 2: \(part2(input))")
}
