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
  var part1Steps = 0

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
        self.part1Steps += 1
      }

      if pos.x < 0 || pos.x > maxX || pos.y < 0 || pos.y > maxY {
        self.visitedSet1 = visited
        return visited.count
      } else {
        visited.insert(pos)
      }
    }
  }

  func part2(_ input: Input) async -> Part2 {
    let (arr, posInitial) = input
    let maxY = arr.count - 1
    let maxX = arr[0].count - 1

    let maxSteps = self.part1Steps
    let bs = self.blocks
    let tasks = self.visitedSet1.map {b in 
      Task {
        var blocks2 = Set(bs)
        blocks2.insert(b)
        return solve2(blocks: blocks2, initialPos: posInitial, maxX: maxX, maxY: maxY, maxSteps: maxSteps)
      }
    }

    var sum = 0
    for t in tasks {
      if await t.result.get() {
        sum += 1
      }
    }

    return sum
  }
}

func solve2(blocks: Set<Pos>, initialPos: Pos, maxX: Int, maxY: Int, maxSteps: Int) -> Bool {
    var d = Pos(x: 0, y: -1)
    var pos = initialPos
    var steps = 0
    while true {
      let pos2 = pos.add(d)
      if blocks.contains(pos2) {
        d = d.turnRight()
        continue
      } else {
        pos = pos2
        steps += 1
      }

      if steps > 2 * maxSteps {
        return true
      } else if pos.x < 0 || pos.x > maxX || pos.y < 0 || pos.y > maxY {
        return false
      }
    }
  }

struct Pos {
  let x: Int
  let y: Int

  func add(_ p2: Pos) -> Pos {
    Pos(x: self.x + p2.x, y: self.y + p2.y)
  }

  func subtract(_ p2: Pos) -> Pos {
    Pos(x: self.x - p2.x, y: self.y - p2.y)
  }

  func factor(_ i: Int) -> Pos {
    Pos(x: self.x * i, y: self.y * i)
  }

  func turnRight() -> Pos {
    Pos(x: -self.y, y: self.x)
  }

  func neighbours4() -> [Pos] {
    [(-1, 0), (1, 0), (0, -1), (0, 1)].map { d in
      self.add(Pos(x:d.0, y:d.1))
    }
  }

  func neighbours8 () -> [Pos] {
    [(-1, -1), (0, -1), (1, -1), (-1, 0), (1, 0), (-1, 1), (0, 1), (1, 1)].map { d in
      self.add(Pos(x:d.0, y:d.1))
    }
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
