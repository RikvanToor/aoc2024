import Parsing

class Day13: Day {

  typealias Input = [(Pos, Pos, Pos)]

  func parse(_ input: String) -> Input {
    let p: some Parser<Substring, (Pos, Pos, Pos)> = Parse {
      "Button A: X+"
      Int.parser()
      ", Y+"
      Int.parser()
      "\nButton B: X+"
      Int.parser()
      ", Y+"
      Int.parser()
      "\nPrize: X="
      Int.parser()
      ", Y="
      Int.parser()
    }.map { (Pos(x: $0, y: $1), Pos(x: $2, y: $3), Pos(x: $4, y: $5)) }

    let ps = Many {
      p
    } separator: {
      "\n\n"
    }
    do {
      let res = try ps.parse(input)
      return res
    } catch {
      return []
    }
  }

  func solve(_ input: Input) -> Int {
    input.map { (ad, bd, goal) in
      let afactor = ad.x * ad.y
      let c1 = ad.y * goal.x
      let b1 = -bd.x * ad.y
      let c2 = ad.x * goal.y
      let b2 = -bd.y * ad.x
      let fullb = b1 - b2
      let fullConst = c2 - c1
      let b = fullConst / fullb
      let a = (c1 + (b1 * b)) / afactor
      if fullConst % fullb == 0 && (c1 + (b1 * b)) % afactor == 0 {
        return 3 * a + b
      }
      return 0
    }.reduce(0, +)
  }

  func part1(_ input: Input) -> Part1 {
    solve(input)
  }

  func part2(_ input: Input) -> Part2 {
    solve(
      input.map { (ad, bd, goal) in
        (ad, bd, goal.add(Pos(x: 10_000_000_000_000, y: 10_000_000_000_000)))
      })
  }
}
