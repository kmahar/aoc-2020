import Foundation

enum Input {
    case mask(String)
    case write(address: Int, value: Int)

    init(_ s: Substring) {
        let components = s.components(separatedBy: " = ")
        if components[0] == "mask" {
            self = .mask(components[1])
        } else {
            // drop the "mem[" and "]"
            let addr = Int(components[0].dropFirst(4).dropLast())!
            let value = Int(components[1])!
            self = .write(address: addr, value: value)
        }
    }
}

func apply1(mask: String, to value: Int) -> Int {
    var outcome = value
    for (i, bit) in mask.enumerated() where bit != "X" {
        switch bit {
        case "0":
            let setTo0Mask = int36Max ^ (1 << (35 - i))
            outcome &= setTo0Mask
        case "1":
            let setTo1Mask = 1 << (35 - i)
            outcome |= setTo1Mask
        default:
            fatalError("Unrecognized value \(bit) in mask")
        }
    }
    return outcome
}

func apply2(mask: String, to address: Int) -> [Int] {
    var addresses = [address]
    for (i, bit) in mask.enumerated() where bit != "0" {
        // masks to set the ith bit to 1 or 0
        let setTo1Mask = 1 << (35 - i)
        let setTo0Mask = int36Max ^ (1 << (35 - i))
        switch bit {
        case "1":
            for i in 0 ..< addresses.count {
                addresses[i] |= setTo1Mask
            }
        case "X":
            var newAddresses = [Int]()
            for addr in addresses {
                // if the bit is already 1, set it to 0
                if addr & setTo1Mask != 0 {
                    newAddresses.append(addr & setTo0Mask)
                    // else it is 0, set it to 1
                } else {
                    newAddresses.append(addr | setTo1Mask)
                }
            }
            addresses += newAddresses
        default:
            fatalError("Unrecognized value \(bit) in mask")
        }
    }

    return addresses
}

let int36Max = Int(pow(2.0, 36)) - 1

func day14() throws {
    let input = try readLines(forDay: 14).map { Input($0) }
    var memory1 = [Int: Int]()
    var currentMask: String!

    for line in input {
        switch line {
        case let .mask(m):
            currentMask = m
        case let .write(addr, value):
            let maskedValue = apply1(mask: currentMask, to: value)
            memory1[addr] = maskedValue
        }
    }

    print("Part 1: \(memory1.values.reduce(0, +))")

    var memory2 = [Int: Int]()
    for line in input {
        switch line {
        case let .mask(m):
            currentMask = m
        case let .write(addr, value):
            let maskedAddresses = apply2(mask: currentMask, to: addr)
            for addr in maskedAddresses {
                memory2[addr] = value
            }
        }
    }

    print("Part 2: \(memory2.values.reduce(0, +))")
}
