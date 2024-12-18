import Parsing
import SwiftPriorityQueue

class Day18: Day {

  typealias Input = [Pos]

  func parse(_ input: String) -> Input {
    let p: some Parser<Substring, [Pos]> = Many {
      Parse {
        Int.parser()
        ","
        Int.parser()
      }.map { (x, y) in Pos(x: x, y: y) }
    } separator: {
      "\n"
    }

    do {
      let res = try p.parse(input)
      return res
    } catch {
      return []
    }
  }

  func printList(_ corrupted: Input, _ maxX: Int, _ maxY: Int) {
    var s = ""
    for y in 0...maxY {
      for x in 0...maxX {
        if corrupted.contains(Pos(x: x, y: y)) {
          s += "#"
        } else {
          s += "."
        }
      }
      s += "\n"
    }
    print(s)
  }

  func buildMap(_ input: Input, _ maxX: Int, _ maxY: Int) -> [Pos: Character] {
    var res: [Pos: Character] = [:]
    for y in 0...maxY {
      for x in 0...maxX {
        res[Pos(x: x, y: y)] = "."
      }
    }
    for p in input {
      res[p] = "#"
    }
    return res
  }

  func part1(_ input: Input) -> Part1 {
    let maxX = input.map { $0.x }.max()!
    let maxY = input.map { $0.y }.max()!
    let map = buildMap(Array(input[0...1023]), maxX, maxY)

    let path = dijkstra(
      start: Node<Pos>(Pos(x: 0, y: 0), 0),
      neighbours: { n in
        var ns: Set<Node<Pos>> = []
        for dt in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
          let d = Pos(x: dt.0, y: dt.1)
          let npos = n.val.add(Pos(x: d.x, y: d.y))
          if map[npos] == "." {
            ns.insert(Node(npos, n.cost + 1))
          }
        }
        return ns
      },
      isGoal: { p in
        p.x == maxX && p.y == maxY
      })

    return (path?.count.advanced(by: -1)) ?? 0
  }

  typealias Part2 = String

  func part2(_ input: Input) -> Part2 {
    let maxX = input.map { $0.x }.max()!
    let maxY = input.map { $0.y }.max()!
    var map = buildMap(Array(input[0...1023]), maxX, maxY)

    for i in 1024...input.count - 1 {
      map[input[i]] = "#"
      let path = dijkstra(
        start: Node<Pos>(Pos(x: 0, y: 0), 0),
        neighbours: { n in
          var ns: Set<Node<Pos>> = []
          for dt in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
            let d = Pos(x: dt.0, y: dt.1)
            let npos = n.val.add(Pos(x: d.x, y: d.y))
            if map[npos] == "." {
              ns.insert(Node(npos, n.cost + 1))
            }
          }
          return ns
        },
        isGoal: { p in
          p.x == maxX && p.y == maxY
        })
      if path == nil {
        let p = input[i]
        print(i)
        return "\(String(p.x)),\(String(p.y))"
      }
    }
    return ""
  }
}

private func dijkstra<T>(start: Node<T>, neighbours: (Node<T>) -> Set<Node<T>>, isGoal: (T) -> Bool)
  -> [T]?
{
  var queue: PriorityQueue<Node<T>> = PriorityQueue(ascending: true)
  queue.push(start)
  var prev: [T: T] = [:]
  var costs: [T: Int] = [start.val: 0]

  func backtrack(_ node: T) -> [T] {
    let prevNode = prev[node]
    if prevNode == nil {
      return [node]
    } else {
      return backtrack(prevNode!) + [node]
    }
  }

  while let cur = queue.pop() {
    for n in neighbours(cur) {
      if costs[n.val] == nil || costs[n.val]! > n.cost {
        costs[n.val] = n.cost
        prev[n.val] = cur.val
        queue.push(n)
      }
    }
  }

  let goal: T? = prev.keys.filter(isGoal).first
  if goal == nil {
    return nil
  } else {
    return backtrack(goal!)
  }
}

private class Node<T: Hashable>: Comparable, Hashable {
  let val: T
  let cost: Int

  init(_ val: T, _ cost: Int) {
    self.val = val
    self.cost = cost
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(val)
    hasher.combine(cost)
  }

  static func < (lhs: Node<T>, rhs: Node<T>) -> Bool {
    return lhs.cost < rhs.cost
  }

  static func <= (lhs: Node, rhs: Node) -> Bool {
    return lhs.cost <= rhs.cost
  }

  static func == (lhs: Node, rhs: Node) -> Bool {
    return lhs === rhs
  }
}
