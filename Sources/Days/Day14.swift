import Parsing

class Day14: Day {

  typealias Input = [(Pos, Pos)]

  func parse(_ input: String) -> Input {
    let p: some Parser<Substring, (Pos, Pos)> = Parse {
      "p="
      Int.parser()
      ","
      Int.parser()
      " v="
      Int.parser()
      ","
      Int.parser()
    }.map { (Pos(x: $0, y: $1), Pos(x: $2, y: $3)) }

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

  func mod(_ a: Int, _ b: Int) -> Int {
    let t = a % b
    if t < 0 {
      return b + t
    } else {
      return t
    }
  }

  func part1(_ input: Input) -> Part1 {
    var minX = 0, minY = 0, maxX = 0, maxY = 0
    for (p, _) in input {
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
    let width = maxX + 1
    let height = maxY + 1
    let res = input.map {(p,v) in 
      let t = p.add(v.factor(100))
      return Pos(x: mod(t.x, width), y: mod(t.y, height))
    }
    var s = ""
    for y in 0...maxY {
      for x in 0...maxX {
        let count = res.filter{p in p.x == x && p.y == y}.count
        if count == 0 {
          s += "."
        } else {
          s += String(count)
        }
      }
      s += "\n"
    }
    var qs = [[0, 0], [0, 0]]
    for p in res {
      if p.x == maxX / 2 || p.y == maxY / 2 {
        continue
      }
      let qy = p.y < maxY / 2 ? 0 : 1
      let qx = p.x < maxX / 2 ? 0 : 1
      qs[qy][qx] += 1
    }
    return qs.flatMap{q in q}.reduce(1, *)
  }

  func part2(_ input: Input) -> Part2 {
    var maxX = 0, maxY = 0
    for (p, _) in input {
      if p.x > maxX {
        maxX = p.x
      }
      if p.y > maxY {
        maxY = p.y
      }
    }
    let width = maxX + 1
    let height = maxY + 1
    
    for i in 0... {
      let res = input.map {(p,v) in 
        let t = p.add(v.factor(i))
        return Pos(x: mod(t.x, width), y: mod(t.y, height))
      }
      var arr = (0...maxY).map{_ in (0...maxX).map{_ in 0}}
      for p in res {
        arr[p.y][p.x] += 1
      }
      for y in 0...maxY-tree.count+1 {
        for x in 0...maxX-tree[0].count+1 {
          var isTree = true
          treeLoop: for y2 in 0...tree.count-1 {
            for x2 in 0...tree[y2].count-1 {
              if arr[y+y2][x+x2] != tree[y2][x2] {
                isTree = false
                break treeLoop
              }
            }
          }
          if isTree {
            return i
          }
        }
      }
    }
    return 0
  }

  let tree: [[Int]] = [
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1],
  [1,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]

}
