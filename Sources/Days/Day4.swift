class Day4: Day {

  typealias Input = [[Character]]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map({ l in Array(l) })
  }

  func part1(_ input: Input) -> Part1 {
    var sum = 0
    for (y, l) in input.enumerated() {
      for (x, c) in l.enumerated() {
        if c == "X" {
          let spaceRight = x <= l.count - 4
          let spaceDown = y <= input.count - 4
          if spaceRight {
            if l[x + 1] == "M" && l[x + 2] == "A" && l[x + 3] == "S" {
              sum += 1
            }
          }
          if spaceDown {
            if input[y + 1][x] == "M" && input[y + 2][x] == "A" && input[y + 3][x] == "S" {
              sum += 1
            }

            if spaceRight {
              if input[y + 1][x + 1] == "M" && input[y + 2][x + 2] == "A"
                && input[y + 3][x + 3] == "S"
              {
                sum += 1
              }
            }
            if x >= 3 {
              if input[y + 1][x - 1] == "M" && input[y + 2][x - 2] == "A"
                && input[y + 3][x - 3] == "S"
              {
                sum += 1
              }
            }
          }
        } else if c == "S" {
          let spaceRight = x <= l.count - 4
          let spaceDown = y <= input.count - 4
          if spaceRight {
            if l[x + 1] == "A" && l[x + 2] == "M" && l[x + 3] == "X" {
              sum += 1
            }
          }
          if spaceDown {
            if input[y + 1][x] == "A" && input[y + 2][x] == "M" && input[y + 3][x] == "X" {
              sum += 1
            }

            if spaceRight {
              if input[y + 1][x + 1] == "A" && input[y + 2][x + 2] == "M"
                && input[y + 3][x + 3] == "X"
              {
                sum += 1
              }
            }
            if x >= 3 {
              if input[y + 1][x - 1] == "A" && input[y + 2][x - 2] == "M"
                && input[y + 3][x - 3] == "X"
              {
                sum += 1
              }
            }
          }
        }
      }
    }
    return sum
  }

  func part2(_ input: Input) -> Part2 {
    var sum = 0
    for (y, l) in input.enumerated() {
      for (x, c) in l.enumerated() {
        if y >= 1 && y <= input.count - 2 && x >= 1 && x <= l.count - 2 && c == "A" {
          if ((input[y - 1][x - 1] == "M" && input[y + 1][x + 1] == "S")
            || (input[y - 1][x - 1] == "S" && input[y + 1][x + 1] == "M"))
            && ((input[y - 1][x + 1] == "M" && input[y + 1][x - 1] == "S")
              || (input[y - 1][x + 1] == "S" && input[y + 1][x - 1] == "M"))
          {
            sum += 1
          }
        }
      }
    }
    return sum
  }
}
