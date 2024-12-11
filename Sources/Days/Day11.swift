class Day11: Day {

  typealias Input = [Int]
  var splitMemo: [Int: (Int, (Int, Int))] = [:]
  var bigMemo: [Pos: Int] = [:]

  func parse(_ input: String) -> Input {
    input.split(separator: " ").map { x in Int(x)! }
  }

  func part1(_ input: Input) -> Part1 {
    input.map { i in runUntilMemo(i, 25) }.reduce(0, +)
  }

  func untilSplit(_ i: Int) -> (Int, (Int, Int)) {
    var cur = i
    var steps = 1
    while true {
      if cur == 0 {
        cur = 1
      } else {
        let digits = String(cur).count
        if digits % 2 == 0 {
          let factor = pow(10, digits / 2)
          return (steps, (cur / factor, cur % factor))
        } else {
          cur *= 2024
        }
      }
      steps += 1
    }
  }

  func untilSplitMemo(_ i: Int) -> (Int, (Int, Int)) {
    switch splitMemo[i] {
    case nil:
      let res = untilSplit(i)
      splitMemo[i] = res
      return res
    case .some(let res):
      return res
    }
  }

  func runUntil(_ i: Int, _ start: Int = 75) -> Int {
    if start <= 0 {
      return 1
    }
    let (steps, (spl1, spl2)) = untilSplitMemo(i)
    let totalSteps = start - steps
    if totalSteps < 0 {
      return 1
    }
    return runUntilMemo(spl1, totalSteps) + runUntilMemo(spl2, totalSteps)
  }

  func runUntilMemo(_ i: Int, _ start: Int = 75) -> Int {
    let pos = Pos(x: i, y: start)
    switch bigMemo[pos] {
    case nil:
      let res = runUntil(i, start)
      bigMemo[pos] = res
      return res
    case .some(let res):
      return res
    }
  }

  func part2(_ input: Input) -> Part2 {
    input.map { i in runUntil(i, 75) }.reduce(0, +)
  }
}
