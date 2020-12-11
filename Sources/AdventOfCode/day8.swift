enum Instruction {
    case acc(Int)
    case jmp(Int)
    case nop(Int)

    init(_ value: Substring) {
        let parts = value.split(separator: " ")
        let intVal = Int(parts[1])!
        switch parts[0] {
        case "acc":
            self = .acc(intVal)
        case "jmp":
            self = .jmp(intVal)
        case "nop":
            self = .nop(intVal)
        default:
            fatalError("unrecognized instruction \(value)")
        }
    }
}

/// Runs the provided program until an infinite loop is detected or the program terminates.
/// Returns the final value of the accumulator, and a bool indicating whether the program
/// successfully terminated.
func runUntilLoopOrTermination(_ instructions: [Instruction]) -> (acc: Int, terminated: Bool) {
    // initial accumulator value.
    var accumulator = 0
    // index of the instruction we are going to execute next.
    var iP = 0
    // indexes of instructions we've already executed.
    var executedInstructionIdxs = Set<Int>()

    while true {
        // termination condition: attempting to run instruction after last instruction
        if iP == instructions.count {
            break
        }

        // We are about to execute an instruction again, this is an infinite loop.
        guard !executedInstructionIdxs.contains(iP) else {
            return (accumulator, false)
        }

        executedInstructionIdxs.insert(iP)

        switch instructions[iP] {
        case let .acc(value):
            accumulator += value
            iP += 1
        case let .jmp(value):
            iP += value
        case .nop:
            iP += 1
        }
    }

    return (accumulator, true)
}

func day8() throws {
    let instructions = try readLines(forDay: 8).map { Instruction($0) }

    let (part1, _) = runUntilLoopOrTermination(instructions)
    print("Part 1: \(part1)")

    // for each index, if it is a nop or jmp, flip it and try running the program.
    for i in 0 ..< instructions.count {
        var copy = instructions
        switch instructions[i] {
        case .acc:
            continue
        case let .nop(value):
            copy[i] = .jmp(value)
        case let .jmp(value):
            copy[i] = .nop(value)
        }

        let (acc, terminated) = runUntilLoopOrTermination(copy)
        if terminated {
            print("Part 2: \(acc)")
            break
        }
    }
}
