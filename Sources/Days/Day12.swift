class Day12: Day {

  typealias Input = [[Character]]
  var regions: [(Character, Set<Pos>)] = []

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map { l in Array(l) }
  }

  func part1(_ input: Input) -> Part1 {
    let maxY = input.count - 1
    let maxX = input[0].count - 1
    var availablePoses: Set<Pos> = Set((0...maxY).flatMap { y in (0...maxX).map { x in Pos(x: x, y: y) } })
    let im: [Pos: Character] = availablePoses.reduce(
      [:],
      { (d, pos) in
        let res = input[pos.y][pos.x]
        var d2 = d
        d2[pos] = res
        return d2
      })
    while availablePoses.count > 0 {
      let start = availablePoses.first!
      var seen: Set<Pos> = []
      var queue: [Pos] = [start]
      
      while let cur = queue.popLast() {
        let (inserted, _) = seen.insert(cur)
        if !inserted {
          continue
        }
        let c = im[cur]!
        let neighbours = [Pos(x:-1,y:0), Pos(x:1,y:0), Pos(x:0, y:-1), Pos(x:0,y:1)]
          .map {d in cur.add(d)}
          .filter { p in im[p] == c }
        queue.append(contentsOf: neighbours)
      }
      regions.append((im[start]!, seen))
      for s in seen {
        availablePoses.remove(s)
      }
    }

    return regions.map {(_, ps) in 
      let perimeter = ps.map {p in 4 - [Pos(x:-1,y:0), Pos(x:1,y:0), Pos(x:0, y:-1), Pos(x:0,y:1)].map {d in p.add(d)}.filter { p2 in ps.contains(p2)}.count }.reduce(0, +)
      let area = ps.count
      return perimeter * area
    }.reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    var res = 0
    for (_, ps) in regions {
      var minX = 0, maxX = 0, minY = 0, maxY = 0
      for p in ps {
        if p.x < minX {
          minX = p.x
        }
        if p.x > maxX {
          maxX = p.x
        }
        if p.y < minY {
          minY = p.y
        }
        if p.y > maxY {
          maxY = p.y
        }
      }

      var edgeCounter = 0

      for y in minY...maxY {
        var topLine = false, botLine = false
        for x in minX...maxX {
          if ps.contains(Pos(x:x,y:y)) {
            if !ps.contains(Pos(x:x,y:y-1)) {
              if !topLine {
                topLine = true
                edgeCounter += 1
              }
            } else {
              topLine = false
            }
            if !ps.contains(Pos(x:x,y:y+1)) {
              if !botLine {
                botLine = true
                edgeCounter += 1
              }
            } else {
              botLine = false
            }
          } else {
            topLine = false
            botLine = false
          }
        }
      }
      res += edgeCounter * 2 * ps.count
    }
    return res
  }
}
