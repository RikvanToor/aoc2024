import Parsing

class Day7: Day {

  typealias Input = [(Int, [Int])]

  func parse(_ input: String) -> Input {
    let p: some Parser<Substring, (Int, [Int])> = Parse {
      Int.parser()
      ": "
      Many {
        Int.parser()
      } separator: {
        " "
      }
    }

    let ps = Many {
      p
    } separator: {
      "\n"
    }
    do {
      let res = try ps.parse(input)
      return res
    } catch {
      return []
    }
  }

  func solve(goal: Int, current: Int, steps: ArraySlice<Int>, ops: [(Int, Int) -> Int]) -> Bool {
    if steps.count == 0 {
      return current == goal
    }
    let next = steps.first!
    let tail = steps.dropFirst()
    return ops.map {o in 
      solve(goal: goal, current: o(current, next), steps: tail, ops: ops)
    }.reduce(false, {(a,b) in 
      a || b
    })
  }

  func run(input: Input, ops: [(Int, Int) -> Int]) -> Int {
    input.map {(goal, ns) in
      if solve(goal: goal, current: ns[0], steps: ns[1...], ops: ops) {
        goal
      } else {
        0
      }
    }.reduce(0, +)
  }

  func part1(_ input: Input) -> Part1 {
    run(input: input, ops: [(+), (*)])
  }

  func part2(_ input: Input) -> Part2 {
    run(input: input, ops: [(+), (*), {(x,y) in x * pow(10, String(y).count) + y}])
  }
}

func pow(_ x: Int, _ y: Int) -> Int {
    if y == 1 {
      return x
    } else {
      return x * pow(x, y-1)
    }
  }