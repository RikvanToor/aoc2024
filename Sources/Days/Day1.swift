class Day1: Day {
  typealias Input = [(Int, Int)]

  func parse(_ input: String) -> Input {
    input
      .split(separator: "\n")
      .map({ x in
        let ws = x.split(separator: " ")
        return (Int(ws[0]) ?? 0, Int(ws[1]) ?? 0)
      })
  }

  func part1(_ input: Input) -> Part1 {
    let left = input.map({ (x, y) in x })
    let right = input.map({ (x, y) in y })
    return zip(left.sorted(), right.sorted())
      .map({ (x, y) in abs(x - y) })
      .reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    let left = input.map({ (x, y) in x })
    let right = input.map({ (x, y) in y })
    return
      left
      .map({ x in x * right.filter({ y in y == x }).count })
      .reduce(0, +)
  }
}