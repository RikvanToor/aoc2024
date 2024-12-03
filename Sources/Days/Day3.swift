class Day3: Day {

  typealias Input = String

  func parse(_ input: String) -> Input {
    input
  }

  func part1(_ input: Input) -> Part1 {
    do {
      let r = try Regex("mul\\(([0-9]{1,3}),([0-9]{1,3})\\)")
      let ms = input.matches(of: r)
      return ms.map({ m in
        Int(m[1].substring!)! * Int(m[2].substring!)!
      }).reduce(0, +)
    } catch {
      return 0
    }
  }

  func part2(_ input: Input) -> Part2 {
    do {
      let r = try Regex("mul\\(([0-9]{1,3}),([0-9]{1,3})\\)|do\\(\\)|don't\\(\\)")
      let ms = input.matches(of: r)
      var doing = true
      var sum = 0
      for m in ms {
        if m[0].substring == "do()" {
          doing = true
        } else if m[0].substring == "don't()" {
          doing = false
        } else if doing {
          sum += Int(m[1].substring!)! * Int(m[2].substring!)!
        }
      }
      return sum
    } catch {
      return 0
    }
  }
}
