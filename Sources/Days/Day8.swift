class Day8: Day {

  typealias Input = ([Character: [Pos]], Int, Int)

  func parse(_ input: String) -> Input {
    var antennas: [Character: [Pos]] = [:]
    let lines = input.split(separator: "\n")
    lines.enumerated()
      .forEach { (y, l) in
        l.enumerated().forEach { (x, c) in
          switch c {
          case ".": ()
          default:
            antennas[c, default: []].append(Pos(x: x, y: y))
          }
        }
      }
    return (antennas, lines[0].count - 1, lines.count - 1)
  }

  func part1(_ input: Input) -> Part1 {
    let (antennas, maxX, maxY) = input
    var antinodes: Set<Pos> = []
    for (_, poses) in antennas {
      for (p1, p2) in combinations(poses) {
        let d1 = p2.subtract(p1)
        let d2 = p1.subtract(p2)
        for an in [p1.subtract(d1), p2.subtract(d2)] {
          if an.x >= 0 && an.x <= maxX && an.y >= 0 && an.y <= maxY {
            antinodes.insert(an)
          }
        }
      }
    }

    return antinodes.count
  }

  func part2(_ input: Input) -> Part2 {
    let (antennas, maxX, maxY) = input
    var antinodes: Set<Pos> = []
    for (_, poses) in antennas {
      for (p1, p2) in combinations(poses) {
        let d = p2.subtract(p1)
        antinodes.insert(p1)
        for i in 1... {
          let an = p1.add(d.factor(i))
          if an.x >= 0 && an.x <= maxX && an.y >= 0 && an.y <= maxY {
            antinodes.insert(an)
          } else {
            break
          }
        }
        for i in 1... {
          let an = p1.add(d.factor(-i))
          if an.x >= 0 && an.x <= maxX && an.y >= 0 && an.y <= maxY {
            antinodes.insert(an)
          } else {
            break
          }
        }
      }
    }

    return antinodes.count
  }
}

func combinations<T>(_ l: [T]) -> [(T, T)] {
  var res: [(T, T)] = []
  for (i, p1) in l.enumerated() {
    for p2 in l.dropFirst(i + 1) {
      res.append((p1, p2))
    }
  }
  return res
}
