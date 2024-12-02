class Day2: Day {
  typealias Input = [[Int]]

  func parse(_ input: String) -> Input {
    input
      .split(separator: "\n")
      .map({ l in l.split(separator: " ").map({ x in Int(x)! }) })
  }

  func check_row(_ row: [Int]) -> Bool {
    let increasing = row[1] > row[0]
    var valid = true
    for i in 1...row.count - 1 {
      if increasing {
        valid = row[i] > row[i - 1] && row[i] - row[i - 1] <= 3
      } else {
        valid = row[i] < row[i - 1] && row[i] - row[i - 1] >= -3
      }
      if !valid {
        break
      }
    }
    return valid
  }

  func part1(_ input: Input) -> Part1 {
    input.filter(check_row).count
  }

  func any_valid(_ to_check: [[Int]]) -> Bool {
    for row in to_check {
      let valid = check_row(row)
      if valid {
        return true
      }
    }
    return false
  }

  func part2(_ input: Input) -> Part2 {
    return input.filter({ row_og in
      var to_check: [[Int]] = []
      to_check.insert(row_og, at: 0)
      for i in 0...row_og.count - 1 {
        var copy = row_og
        copy.remove(at: i)
        to_check.insert(copy, at: 1)
      }

      return any_valid(to_check)
    }).count
  }
}
