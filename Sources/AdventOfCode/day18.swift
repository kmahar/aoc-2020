enum MathCharacter: Equatable {
    case number(Int)
    case plus
    case times
    case leftParen
    case rightParen

    init(_ c: Character) {
        switch c {
        case "(":
            self = .leftParen
        case ")":
            self = .rightParen
        case "+":
            self = .plus
        case "*":
            self = .times
        default:
            let num = Int(String(c))!
            self = .number(num)
        }
    }

    /// Returns a boolean indicating whether the precedence of self is greater than or equal to that of `other`.
    func hasGTEPrecedence(to other: MathCharacter, plusTakesPrecedence: Bool) -> Bool {
        switch (self, other) {
        case (.times, .times), (.plus, .plus), (.plus, .times):
            return true
        case (.times, .plus):
            return !plusTakesPrecedence
        default:
            fatalError("Precedence comparisons not supported for characters \(self) and \(other)")
        }
    }
}

/// Converts an expression in infix notation to postfix notation.
/// https://en.wikipedia.org/wiki/Shunting-yard_algorithm#The_algorithm_in_detail
func runShuntingYardAlgorithm(_ expression: [MathCharacter], plusTakesPrecedence: Bool = false) -> [MathCharacter] {
    var outputQueue = [MathCharacter]()
    // last element is the top of the stack.
    var operatorStack = [MathCharacter]()

    for token in expression {
        switch token {
        case .number:
            outputQueue.append(token)
        case .plus, .times:
            while !operatorStack.isEmpty,
                  operatorStack.last! != .leftParen,
                  operatorStack.last!.hasGTEPrecedence(to: token, plusTakesPrecedence: plusTakesPrecedence)
            {
                outputQueue.append(operatorStack.popLast()!)
            }
            operatorStack.append(token)
        case .leftParen:
            operatorStack.append(token)
        case .rightParen:
            while operatorStack.last! != .leftParen {
                outputQueue.append(operatorStack.popLast()!)
            }
            guard operatorStack.popLast() == .leftParen else {
                fatalError("Mismatched parentheses in expression \(expression)")
            }
        }
    }

    while let next = operatorStack.popLast() {
        switch next {
        case .leftParen, .rightParen:
            fatalError("Mismatched parentheses in expression \(expression)")
        default:
            outputQueue.append(next)
        }
    }

    return outputQueue
}

/// Evaluates a mathematical expression in postfix form.
func evaluate(_ expression: [MathCharacter]) -> Int {
    // last element is the top of the stack.
    var stack = [Int]()
    for token in expression {
        switch token {
        case let .number(value):
            stack.append(value)
        case .plus:
            let v1 = stack.popLast()!
            let v2 = stack.popLast()!
            stack.append(v1 + v2)
        case .times:
            let v1 = stack.popLast()!
            let v2 = stack.popLast()!
            stack.append(v1 * v2)
        default:
            fatalError("Unexpectedly encountered character \(token) in postfix expression")
        }
    }

    return stack.popLast()!
}

func day18() throws {
    let input = try readLines(forDay: 18).map { Array($0).filter { $0 != " " }.map { MathCharacter($0) } }

    let part1 = input.map { runShuntingYardAlgorithm($0) }.map { evaluate($0) }.reduce(0, +)
    print("Part 1: \(part1)")

    let part2 = input.map { runShuntingYardAlgorithm($0, plusTakesPrecedence: true) }.map { evaluate($0) }.reduce(0, +)
    print("Part 2: \(part2)")
}
