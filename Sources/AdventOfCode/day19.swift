enum Rule {
    /// Matches a single character.
    case character(Character)
    /// Matches 1+ rules in a row, with id #s specified by the provided values.
    indirect case and([Int])
    /// Matches either of the provided groups of 1 or more rules specified by the provided values.
    indirect case or([[Int]])

    init(_ s: Substring) {
        let components = s.split(separator: " ")
        if components.count == 1 {
            let comp = components[0]
            // first see if it's a rule number
            if let intValue = Int(comp) {
                self = .and([intValue])
                return
            }
            // otherwise, assume it's a character
            let character = Character(String(comp.dropFirst().dropLast())) // drop quotation marks
            self = .character(character)
            return
        }

        if components.contains("|") {
            var ors = [[Int]]()
            for part in components.split(separator: "|") {
                ors.append(part.map { Int($0)! })
            }
            self = .or(ors)
            return
        }

        self = .and(components.map { Int($0)! })
    }

    func matches(_ message: Substring, rules: [Int: Rule]) -> (Bool, Substring) {
        switch self {
        case let .character(char):
            return (message.first == char, message.dropFirst())
        case let .and(andRules):
            var remaining = message
            for r in andRules {
                let (matches, rem) = rules[r]!.matches(remaining, rules: rules)
                if !matches {
                    return (false, remaining)
                }
                remaining = rem
            }
            return (true, remaining)
        case let .or(orRules):
            for ruleSet in orRules {
                let (matches, remaining) = Rule.and(ruleSet).matches(message, rules: rules)
                if matches {
                    return (true, remaining)
                }
            }
            return (false, message)
        }
    }
}

func day19() throws {
    let input = try readLines(forDay: 19, omittingEmptySubsequences: false)
    let inputComponents = input.split(separator: "")

    var rules = [Int: Rule]()
    inputComponents[0].forEach { ruleDescription in
        let components = ruleDescription.split(separator: " ", maxSplits: 1)
        let id = Int(components[0].dropLast())!
        let rule = Rule(components[1])
        rules[id] = rule
    }

    let messages = inputComponents[1]
    let rule0 = rules[0]!
    let matchCount1 = messages.filter { msg in
        let (matches, remaining) = rule0.matches(msg, rules: rules)
        return matches && remaining.isEmpty
    }.count
    print("Part 1: \(matchCount1)")

    // this is currently broken
    rules[8] = Rule.or([[42], [42, 8]])
    rules[11] = Rule.or([[42, 31], [42, 11, 31]])
    let matchCount2 = messages.filter { msg in
        let (matches, remaining) = rule0.matches(msg, rules: rules)
        return matches && remaining.isEmpty
    }.count
    print("Part 2: \(matchCount2)")
}
