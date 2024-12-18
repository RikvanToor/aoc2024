import SwiftPriorityQueue

class Day16: Day {

  typealias Input = [[Character]]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map { l in Array(l) }
  }

  var prev: [PosDir: Set<PosDir>] = [:]
  var dist: [PosDir: Int] = [:]
  var start = PosDir(pos: Pos(x: 0, y: 0), dir: Pos(x: 1, y: 0))
  var goalPos = Pos(x: 0, y: 0)

  func part1(_ input: Input) -> Part1 {
    for (y, row) in input.enumerated() {
      for (x, c) in row.enumerated() {
        if c == "S" {
          start = PosDir(pos: Pos(x: x, y: y), dir: Pos(x: 1, y: 0))
        } else if c == "E" {
          goalPos = Pos(x: x, y: y)
        }
      }
    }
    var queue: PriorityQueue<Node> = PriorityQueue(ascending: true)
    queue.push(Node(start, 0))

    while let cur = queue.pop() {
      var neighs: Set<Node> = [
        Node(
          PosDir(pos: cur.posdir.pos, dir: Pos(x: -cur.posdir.dir.y, y: cur.posdir.dir.x)),
          cur.cost + 1000),
        Node(
          PosDir(pos: cur.posdir.pos, dir: Pos(x: cur.posdir.dir.y, y: -cur.posdir.dir.x)),
          cur.cost + 1000),
      ]
      let newPos = cur.posdir.pos.add(cur.posdir.dir)
      let c = input[newPos.y][newPos.x]
      if c == "." || c == "E" || c == "S" {
        neighs.insert(Node(PosDir(pos: newPos, dir: cur.posdir.dir), cur.cost + 1))
      }

      for n in neighs {
        if dist[n.posdir] == nil || dist[n.posdir]! > n.cost {
          dist[n.posdir] = n.cost
          prev[n.posdir] = [cur.posdir]
          queue.push(n)
        } else if dist[n.posdir]! == n.cost {
          prev[n.posdir] = prev[n.posdir]!.union([cur.posdir])
          queue.push(n)
        }
      }
    }

    func backtrack(_ pd: PosDir) -> [[PosDir]] {
      if prev[pd] == nil || pd.pos == start.pos {
        return [[pd]]
      }
      let prevs = prev[pd]!
      return prevs.flatMap { prs in backtrack(prs).map { p in p + [pd] } }
    }

    let dists: [PosDir] = dist.keys.filter { pd in pd.pos == goalPos }
    return dists.map { pd in dist[pd]! }.min()!
  }

  func part2(_ input: Input) -> Part2 {
    func backtrack(_ pd: PosDir) -> [[PosDir]] {
      if prev[pd] == nil || pd.pos == start.pos {
        return [[pd]]
      }
      let prevs = prev[pd]!
      return prevs.flatMap { prs in backtrack(prs).map { p in p + [pd] } }
    }

    var dists: [PosDir] = dist.keys.filter { pd in pd.pos == goalPos }
    let minCost = dists.map { pd in dist[pd]! }.min()!
    dists = dists.filter { pd in dist[pd] == minCost }
    let paths = dists.flatMap { d in backtrack(d) }
    let poses = Set(paths.flatMap { pds in pds.map { pd in pd.pos } })

    return poses.count
  }
}

private class Node: Comparable, Hashable {
  let posdir: PosDir
  let cost: Int

  init(_ posdir: PosDir, _ cost: Int) {
    self.posdir = posdir
    self.cost = cost
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(posdir)
    hasher.combine(cost)
  }

  static func < (lhs: Node, rhs: Node) -> Bool {
    return lhs.cost < rhs.cost
  }

  static func <= (lhs: Node, rhs: Node) -> Bool {
    return lhs.cost <= rhs.cost
  }

  static func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
  }
}

