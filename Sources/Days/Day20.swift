class Day20: Day {

  typealias Input = (Set<Pos>, Pos, Pos)

  func parse(_ input: String) -> Input {
    let grid = input.split(separator: "\n").map { l in Array(l) }
    var tiles: Set<Pos> = []
    var start = Pos(x: 0, y: 0)
    var end = Pos(x: 0, y: 0)
    for (y, r) in grid.enumerated() {
      for (x, c) in r.enumerated() {
        let p = Pos(x: x, y: y)
        switch c {
        case ".":
          tiles.insert(p)
        case "S":
          tiles.insert(p)
          start = p
        case "E":
          tiles.insert(p)
          end = p
        default:
          continue
        }
      }
    }
    return (tiles, start, end)
  }

  func solve(_ input: Input, _ maxSteps: Int) -> Int {
    let (tiles, start, end) = input

    var maxX = 0
    var maxY = 0
    for t in tiles {
      if t.x > maxX {
        maxX = t.x
      }
      if t.y > maxY {
        maxY = t.y
      }
    }

    var next: Pos? = end
    var prevPos: Pos? = nil
    var baseCosts: [Pos: Int] = [:]
    var prev: [Pos: Pos] = [:]
    var costCounter = 0
    while let cur = next {
      baseCosts[cur] = costCounter
      next = nil
      for n in cur.neighbours4() {
        if tiles.contains(n) && n != prevPos {
          next = n
          prevPos = cur
          prev[n] = cur
          costCounter += 1
          break
        }
      }
    }

    var res = 0
    var cur = start
    while true {
      let curCost = baseCosts[cur]!
      if curCost <= 100 {
        break
      }
      for dy in -maxSteps...maxSteps {
        let xs = maxSteps - abs(dy)
        for dx in -xs...xs {
          if dx == 0 && dy == 0 {
            continue
          }

          let x = cur.x + dx
          let y = cur.y + dy
          if x <= 0 || x > maxX || y <= 0 || y > maxY {
            continue
          }
          let newPos = Pos(x: x, y: y)
          let newCost = baseCosts[newPos]
          if newCost == nil {
            continue
          }
          let cheatDist = abs(dx) + abs(dy)
          let curCost = baseCosts[cur]!
          if newCost! + cheatDist <= curCost - 100 {
            res += 1
          }
        }
      }
      cur = prev[cur]!
    }

    return res
  }

  func part1(_ input: Input) -> Part1 {
    solve(input, 2)
  }

  func part2(_ input: Input) -> Part2 {
    solve(input, 20)
  }

}
