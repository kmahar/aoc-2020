import Foundation

func readFile(forDay day: Int) throws -> String {
    let path = URL(fileURLWithPath: "./Inputs/day\(day)")
    return try String(contentsOf: path, encoding: .utf8)
}

func readLines(forDay day: Int, omittingEmptySubsequences: Bool = true) throws -> [String.SubSequence] {
    return try readFile(forDay: day).split(separator: "\n", omittingEmptySubsequences: omittingEmptySubsequences)
}
