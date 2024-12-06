class Day6: Day {

  typealias Input = ([[Character]], Pos)

  func parse(_ input: String) -> Input {
    var arr = input.split(separator: "\n").map { l in
      Array(l)
    }
    var pos = Pos(x: 0, y: 0)
    for (y, l) in arr.enumerated() {
      for (x, c) in l.enumerated() {
        if c == "^" {
          pos = Pos(x: x, y: y)
          arr[y][x] = "."
        }
      }
    }
    return (arr, pos)
  }

  var visitedSet1: Set<Pos> = []
  var blocks: Set<Pos> = []

  func part1(_ input: Input) -> Part1 {
    let (arr, posInitial) = input
    var pos = posInitial
    let maxY = arr.count - 1
    let maxX = arr[0].count - 1
    var d = Pos(x: 0, y: -1)
    let blocks = arr.enumerated().compactMap { (y, l) in
      l.enumerated().filter { (_, c) in
        c == "#"
      }.map { (x, _) in
        Pos(x: x, y: y)
      }
    }.flatMap { x in x }
    self.blocks = Set(blocks)
    var visited: Set = [pos]
    while true {
      let pos2 = pos.add(d)
      if blocks.contains(pos2) {
        d = d.turnRight()
        continue
      } else {
        pos = pos2
      }

      if pos.x < 0 || pos.x > maxX || pos.y < 0 || pos.y > maxY {
        self.visitedSet1 = visited
        return visited.count
      } else {
        visited.insert(pos)
      }
    }
  }

  func solve2(blocks: Set<Pos>, initialPos: Pos, maxX: Int, maxY: Int) -> (Bool, Set<PosDir>) {
    var d = Pos(x: 0, y: -1)
    var pos = initialPos
    var res: Set<PosDir> = [PosDir(pos: pos, dir: d)]
    while true {
      let pos2 = pos.add(d)
      if blocks.contains(pos2) {
        d = d.turnRight()
        continue
      } else {
        pos = pos2
      }

      if pos.x < 0 || pos.x > maxX || pos.y < 0 || pos.y > maxY {
        return (false, res)
      } else {
        // Loop until we get to a position + direction we've been to before
        let (inserted, _) = res.insert(PosDir(pos: pos, dir: d))
        if !inserted {
          return (true, res)
        }
      }
    }
  }

  func part2(_ input: Input) -> Part2 {
    let (arr, posInitial) = input
    let maxY = arr.count - 1
    let maxX = arr[0].count - 1

    var sum = 0

    for b in self.visitedSet1 {
      var blocks2: Set<Pos> = Set(self.blocks)
      blocks2.insert(b)
      let (loop, _) = solve2(blocks: blocks2, initialPos: posInitial, maxX: maxX, maxY: maxY)
      if loop {
        sum += 1
      }
    }

    return sum
  }
}

struct Pos {
  let x: Int
  let y: Int

  func add(_ p2: Pos) -> Pos {
    Pos(x: self.x + p2.x, y: self.y + p2.y)
  }

  func turnRight() -> Pos {
    Pos(x: -self.y, y: self.x)
  }
}

struct PosDir {
  let pos: Pos
  let dir: Pos
}

extension Pos: Hashable {
  static func == (lhs: Pos, rhs: Pos) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(x)
    hasher.combine(y)
  }
}

extension PosDir: Hashable {
  static func == (lhs: PosDir, rhs: PosDir) -> Bool {
    return lhs.pos == rhs.pos && lhs.dir == rhs.dir
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(pos)
    hasher.combine(dir)
  }
}
