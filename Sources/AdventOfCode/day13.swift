/// Given a and b, finds (x, y) such that ax + by = gcd(a, b).
/// pseudocode from https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode
func extendedGCD(_ a: Int, _ b: Int) -> (Int, Int) {
    var s = 0
    var oldS = 1

    var r = b
    var oldR = a

    while r != 0 {
        let quotient = oldR / r
        (oldR, r) = (r, oldR - quotient * r)
        (oldS, s) = (s, oldS - quotient * s)
    }

    let bezoutT = b == 0 ? 0 : (oldR - oldS * a) / b
    return (oldS, bezoutT)
}

/// Given series a and n, solves a system of linear congruences of the form t ≡ a_1 (mod n_1)... t ≡ a_k (mod n_k).
/// inspired by https://medium.com/@astartekraus/the-chinese-remainder-theorem-ea110f48248c.
func chineseRemainderTheorem(_ aValues: [Int], _ nValues: [Int]) -> Int {
    let N = nValues.reduce(1, *)

    let sol = zip(aValues, nValues).map { a, n in
        a * extendedGCD(n, N / n).1 * (N / n)
    }.reduce(0, +)

    // take modulo to get min solution
    return sol % N
}

func day13() throws {
    let lines = try readLines(forDay: 13)
    let earliestDepartureTime = Int(lines[0])!
    let pattern = lines[1].split(separator: ",")
    let busIDs = pattern.filter { $0 != "x" }.map { Int($0)! }

    var earliestTime: Int?
    var earliestID: Int?
    for id in busIDs {
        let earliest = earliestDepartureTime / id * id + id
        if earliestTime == nil || earliest < earliestTime! {
            earliestTime = earliest
            earliestID = id
        }
    }
    let waitTime = earliestTime! - earliestDepartureTime
    let pt1 = waitTime * earliestID!
    print("Part 1: \(pt1)")

    // We can represent this problem as a series of linear congruences. for e.g. 1789,37,47,1889, we are trying to find
    // a time t such that t % 1789 == 0, t+1 % 37 == 0, t+2 % 47 == 0, t + 3 % 1889 == 0, since time % bus number == 0
    // means that the bus stops at that time. an equivalent set of equations is t ≡ 0 (mod 1789), t ≡ -1 (mod 37),
    // t ≡ -2 (mod 47), t ≡ -3 (mod 1889).
    // to solve a set of linear congruences one can use the Chinese Remainder Theorem, which can find a value t such
    // that a set of equations like these are all satisfied.

    // translate the provided pattern into a series of equations of the form t ≡ a_i (mod n_i).
    var aValues = [Int]()
    var nValues = [Int]()

    for (i, elt) in pattern.enumerated() {
        // if there are no constraints on a time, we do not need to another equation.
        guard elt != "x" else {
            continue
        }
        // the "a" value is the distance the time is from the start time t.
        aValues.append(-1 * i)
        nValues.append(Int(elt)!)
    }

    print("Part 2: \(chineseRemainderTheorem(aValues, nValues))")
}
