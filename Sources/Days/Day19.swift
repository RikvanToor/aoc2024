class Day19: Day {

  typealias Input = ([String], [String])

  func parse(_ input: String) -> Input {
    let lines = input.split(separator: "\n")

    let patterns = lines[0].split(separator: ", ").map { s in String(s) }
    let designs: [String] = Array(lines.dropFirst().map { s in String(s) })
    return (patterns, designs)
  }

  var memo: [Substring: Int] = [:]

  func countInner(_ s: Substring, _ patterns: [String]) -> Int {
    if s.count == 0 {
      return 1
    }
    var sum = 0
    for p in patterns {
      if s.prefix(p.count) == p {
        sum += count(s.dropFirst(p.count), patterns)
      }
    }
    return sum
  }

  func count(_ s: Substring, _ patterns: [String]) -> Int {
    let m = memo[s]
    if m != nil {
      return m!
    } else {
      let res = countInner(s, patterns)
      memo[s] = res
      return res
    }
  }

  func part1(_ input: Input) -> Part1 {
    let (patterns, designs) = input
    return designs.filter { des in
      count(des[...], patterns) > 0
    }.count
  }

  func part2(_ input: Input) -> Part2 {
    let (patterns, designs) = input
    return designs.map { des in
      count(des[...], patterns)
    }.reduce(0, +)
  }
}
