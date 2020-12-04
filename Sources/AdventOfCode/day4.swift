let expectedFields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
let hairColorCharacters = "0123456789abcdef"
let eyeColors = Set(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])

func day4() throws {
    let inputs = try readLines(forDay: 4, omittingEmptySubsequences: false)
    let passportData = inputs.split(separator: "")

    var valid1 = 0
    var valid2 = 0
    for pd in passportData {
        var fieldMap = [String: String]()

        pd.map { $0.split(separator: " ") }
            .reduce([], +)
            .map { $0.split(separator: ":") }
            .forEach { field in
                fieldMap[String(field[0])] = String(field[1])
            }

        guard expectedFields.allSatisfy({ fieldMap.keys.contains($0) }) else { continue }

        // for part 1 we only care about the right fields being present.
        valid1 += 1

        // Part 2
        let byr = fieldMap["byr"]!
        guard let intByr = Int(byr), (1920 ... 2002).contains(intByr) else { continue }

        let iyr = fieldMap["iyr"]!
        guard let intIyr = Int(iyr), (2010 ... 2020).contains(intIyr) else { continue }

        let eyr = fieldMap["eyr"]!
        guard let intEyr = Int(eyr), (2020 ... 2030).contains(intEyr) else { continue }

        let hgt = fieldMap["hgt"]!

        if hgt.hasSuffix("cm") {
            let cms = hgt.dropLast(2)
            guard let intCms = Int(cms), (150 ... 193).contains(intCms) else { continue }
        } else if hgt.hasSuffix("in") {
            let ins = hgt.dropLast(2)
            guard let intIns = Int(ins), (59 ... 76).contains(intIns) else { continue }
        } else {
            continue
        }

        let hcl = fieldMap["hcl"]!
        guard hcl.count == 7, hcl.first == "#", hcl.dropFirst().allSatisfy({ $0.isHexDigit }) else { continue }

        let ecl = fieldMap["ecl"]!
        guard eyeColors.contains(ecl) else { continue }

        let pid = fieldMap["pid"]!
        guard pid.count == 9, pid.allSatisfy({ $0.isNumber }) else { continue }

        valid2 += 1
    }

    print("Part 1: \(valid1)")
    print("Part 2: \(valid2)")
}
