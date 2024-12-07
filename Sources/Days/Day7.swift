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

  func run(input: Input, ops: Ops) async -> Int {
    let tasks = input.map {(goal, ns) in
      Task {
        if solve(goal: goal, current: ns[0], steps: ns[1...], ops: ops) {
          goal
        } else {
          0
        }
      }
    }
    var sum = 0
    for t in tasks {
      sum += await t.result.get()
    }
    return sum
  }

  func part1(_ input: Input) async -> Part1 {
    await run(input: input, ops: .part1)
  }

  func part2(_ input: Input) async -> Part2 {
    await run(input: input, ops: .part2)
  }
}

enum Ops {
  case part1
  case part2
}

nonisolated(unsafe) let ops1: [(Int,Int) -> Int] = [(+), (*)]
nonisolated(unsafe) let ops2: [(Int,Int) -> Int] = [(+), (*), {(x,y) in x * pow(10, String(y).count) + y}]
func getOps(_ o: Ops) -> [(Int,Int) -> Int] {
  switch o {
    case .part1:
      ops1
    case .part2:
      ops2
  }
}

func solve(goal: Int, current: Int, steps: ArraySlice<Int>, ops: Ops) -> Bool {
    if current > goal {
      return false
    }
    if steps.count == 0 {
      return current == goal
    }
    let next = steps.first!
    let tail = steps.dropFirst()
    return getOps(ops).map {o in 
      solve(goal: goal, current: o(current, next), steps: tail, ops: ops)
    }.reduce(false, {(a,b) in 
      a || b
    })
  }


func pow(_ x: Int, _ y: Int) -> Int {
    if y == 1 {
      return x
    } else {
      return x * pow(x, y-1)
    }
  }