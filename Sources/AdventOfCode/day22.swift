struct GameState: Hashable {
    let p1Deck: [Int]
    let p2Deck: [Int]
}

struct GameResult {
    let p1Wins: Bool
    let winnerScore: Int
}

extension Array where Element == Int {
    func calculateScore() -> Int {
        reversed().enumerated().map { i, card in (i + 1) * card }.reduce(0, +)
    }
}

func playRecursiveCombat(p1: [Int], p2: [Int]) -> GameResult {
    var p1 = p1
    var p2 = p2
    var previousRounds = Set<GameState>()

    while !p1.isEmpty, !p2.isEmpty {
        let state = GameState(p1Deck: p1, p2Deck: p2)
        // Before either player deals a card, if there was a previous round in this game that had exactly
        // the same cards in the same order in the same players' decks, the game instantly ends in a win
        // for player 1.
        if previousRounds.contains(state) {
            return GameResult(p1Wins: true, winnerScore: p1.calculateScore())
        }
        previousRounds.insert(state)

        let p1Card = p1.removeFirst()
        let p2Card = p2.removeFirst()

        guard p1.count >= p1Card, p2.count >= p2Card else {
            if p1Card > p2Card {
                p1.append(p1Card)
                p1.append(p2Card)
            } else {
                p2.append(p2Card)
                p2.append(p1Card)
            }
            continue
        }

        let p1Copy = Array(p1.prefix(p1Card))
        let p2Copy = Array(p2.prefix(p2Card))
        let result = playRecursiveCombat(p1: p1Copy, p2: p2Copy)
        if result.p1Wins {
            p1.append(p1Card)
            p1.append(p2Card)
        } else {
            p2.append(p2Card)
            p2.append(p1Card)
        }
    }

    if p1.isEmpty {
        return GameResult(p1Wins: false, winnerScore: p2.calculateScore())
    } else {
        return GameResult(p1Wins: true, winnerScore: p1.calculateScore())
    }
}

func day22() throws {
    let input = try readLines(forDay: 22, omittingEmptySubsequences: false)
    let decks = input.split(separator: "")
    let player1Deck = decks[0].dropFirst().map { Int($0)! }
    let player2Deck = decks[1].dropFirst().map { Int($0)! }

    var p1 = player1Deck
    var p2 = player2Deck
    while !p1.isEmpty, !p2.isEmpty {
        let p1Card = p1.removeFirst()
        let p2Card = p2.removeFirst()
        if p1Card > p2Card {
            p1.append(p1Card)
            p1.append(p2Card)
        } else {
            p2.append(p2Card)
            p2.append(p1Card)
        }
    }

    print("Part 1: \((p1.isEmpty ? p2 : p1).calculateScore())")

    let result = playRecursiveCombat(p1: player1Deck, p2: player2Deck)
    print("Part 2: \(result.winnerScore)")
}
