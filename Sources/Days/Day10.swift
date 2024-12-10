class Day10: Day {

  typealias Input = [[Int]]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map { l in l.map { c in Int(String(c))! } }
  }

  func step(input: Input, maxX: Int, maxY: Int, curPos: Pos) -> [Pos] {
    let curValue = input[curPos.y][curPos.x]
    if input[curPos.y][curPos.x] == 9 {
      return [curPos]
    }

    return [(-1, 0), (1, 0), (0, -1), (0, 1)].map { d in
      let newPos = curPos.add(Pos(x: d.0, y: d.1))
      if newPos.x >= 0 && newPos.x <= maxX && newPos.y >= 0 && newPos.y <= maxY
        && input[newPos.y][newPos.x] == curValue + 1
      {
        return step(input: input, maxX: maxX, maxY: maxY, curPos: newPos)
      } else {
        return []
      }
    }.reduce([], { (a, b) in a + b })
  }

  func run(_ input: Input) -> [[Pos]] {
    let maxY = input.count - 1
    let maxX = input[0].count - 1
    var starts: Set<Pos> = []
    for (y, l) in input.enumerated() {
      for (x, n) in l.enumerated() {
        if n == 0 {
          starts.insert(Pos(x: x, y: y))
        }
      }
    }
    return starts.map { s in
      step(input: input, maxX: maxX, maxY: maxY, curPos: s)
    }
  }

  func part1(_ input: Input) -> Part1 {
    run(input).map { s in
      Set(s).count
    }.reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    run(input).map { s in
      s.count
    }.reduce(0, +)
  }
}
