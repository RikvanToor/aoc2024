class Day25: Day {

  typealias Input = [[[Character]]]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n\n").map { ls in
      ls.split(separator: "\n").map { l in Array(l) }
    }
  }

  func part1(_ input: Input) -> Part1 {
    var locks: [[Int]] = []
    var keys: [[Int]] = []
    for a in input {
      let isLock = a[0].allSatisfy { $0 == "#" }
      let stride = isLock ? stride(from: 1, to: 7, by: 1) : stride(from: 5, to: -1, by: -1)
      let value = (0...4).map { x in
        var sum = 0
        for y in stride {
          if a[y][x] == "#" {
            sum += 1
          } else {
            continue
          }
        }
        return sum
      }
      if isLock {
        locks.append(value)
      } else {
        keys.append(value)
      }
    }

    return keys.map { k in
      locks.filter { l in
        (0...4).allSatisfy { x in
          k[x] + l[x] <= 5
        }
      }.count
    }.reduce(0, +)
  }

  typealias Part2 = String
  func part2(_ input: Input) -> Part2 {
    return "👍"
  }
}
