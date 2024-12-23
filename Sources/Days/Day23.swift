class Day23: Day {

  typealias Input = [(String, String)]

  func parse(_ input: String) -> Input {
    return input.split(separator: "\n").map { l in
      let s = l.split(separator: "-")
      return (String(s[0]), String(s[1]))
    }
  }

  func part1(_ input: Input) -> Part1 {
    var edges: [String: Set<String>] = [:]
    for (x1, x2) in input {
      edges[x1] = (edges[x1] ?? []).union([x2])
      edges[x2] = (edges[x2] ?? []).union([x1])
    }
    var sets: Set<Set<String>> = []
    for x1 in edges.keys.filter({ e in e.first == "t" }) {
      let l = Array(edges[x1]!)
      for i in 0...l.count - 2 {
        for j in i + 1...l.count - 1 {
          if edges[l[i]]?.contains(l[j]) ?? false {
            sets.insert([x1, l[i], l[j]])
          }
        }
      }
    }
    return sets.count
  }

  typealias Part2 = String

  func part2(_ input: Input) -> Part2 {
    var edges: [String: Set<String>] = [:]
    for (x1, x2) in input {
      edges[x1] = (edges[x1] ?? []).union([x2])
      edges[x2] = (edges[x2] ?? []).union([x1])
    }

    func isClique(_ es: Set<String>) -> Bool {
      let l = Array(es)
      for i in 0...l.count - 2 {
        for j in i + 1...l.count - 1 {
          if !(edges[l[i]]?.contains(l[j]) ?? false) {
            return false
          }
        }
      }
      return true
    }

    func bronKerbosch(_ r: Set<String>, _ pi: Set<String>, _ xi: Set<String>) -> Set<Set<String>> {
      var p = pi
      var x = xi
      var res: Set<Set<String>> = []
      if p.count == 0 && x.count == 0 {
        res.insert(r)
      }
      for v in p {
        res = res.union(
          bronKerbosch(r.union([v]), p.intersection(edges[v]!), x.intersection(edges[v]!)))
        p.remove(v)
        x.insert(v)
      }
      return res
    }

    let cliques = bronKerbosch([], Set(edges.keys), [])
    let res = cliques.max { c1, c2 in
      c1.count < c2.count
    }!

    let sorted = Array(res).sorted()
    return sorted.joined(separator: ",")
  }
}
