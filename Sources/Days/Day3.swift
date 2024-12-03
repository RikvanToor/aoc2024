import Parsing

class Day3: Day {

  typealias Input = [Program]

  enum Program {
    case mul(Int, Int)
    case doP
    case dontP
  }

  func parse(_ input: String) -> Input {
    let p = OneOf {
      OneOf {
        Parse {
          "do()"
        }.map({ Program.doP })

        Parse {
          "don't()"
        }.map({ Program.dontP })

        Parse {
          "mul("
          Int.parser()
          ","
          Int.parser()
          ")"
        }.map { Program.mul($0, $1) }

      }.map(Optional.some)
      First().map({ _ in nil })
    }
    let ps = Many {
      p
    }
    do {
      let res = try ps.parse(input).compactMap({ $0 })
      return res
    } catch {
      return []
    }
  }

  func part1(_ input: Input) -> Part1 {
    input.map({
      switch $0 {
      case .mul(let a, let b):
        return a * b
      default:
        return 0
      }
    }).reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    input.reduce(
      (true, 0),
      { (acc, p) in
        let (doing, sum) = acc
        switch p {
        case .doP:
          return (true, sum)
        case .dontP:
          return (false, sum)
        case .mul(let a, let b):
          let res = doing ? sum + a * b : sum
          return (doing, res)
        }
      }
    ).1
  }
}
