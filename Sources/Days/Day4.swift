class Day4: Day {

  typealias Input = [[Character]]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map({ l in Array(l) })
  }

  func part1(_ input: Input) -> Part1 {
    let goal = Array("XMAS")
    return (0...input.count-1).map({y in 
      (0...input[y].count-1).map({x in 
        let l = input[y]
        let dxs = [(-1, 0), (-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1)]
        return dxs.map({ (dx, dy) in
          if (0...3).allSatisfy({ p in
            let (x2, y2) = (x + p * dx, y + p * dy)
            return y2 >= 0 && y2 < l.count && x2 >= 0 && x2 < l.count && input[y2][x2] == goal[p]
          }) {
            return 1
          }
          return 0
        }).reduce(0, +)
      }).reduce(0, +)
    }).reduce(0, +)
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
