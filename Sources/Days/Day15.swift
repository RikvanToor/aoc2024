import Parsing

class Day15: Day {

  typealias Input = ([[Node]], [Pos])

  enum Node {
    case box
    case wall
    case fish
    case empty
  }

  func parse(_ input: String) -> Input {
    let pnode: some Parser<Substring, Node> = OneOf {
      Parse{"#"}.map{.wall}
      Parse{"O"}.map{.box}
      Parse{"@"}.map{.fish}
      Parse{"."}.map{.empty}
    }
    let pnodes = Many {
      pnode
    }
    let pmap = Many {
      pnodes
    } separator: {
      "\n"
    }

    let pmove: some Parser<Substring, Pos> = OneOf {
      "v".map{Pos(x:0,y:1)}
      "^".map{Pos(x:0,y:-1)}
      "<".map{Pos(x:-1,y:0)}
      ">".map{Pos(x:1,y:0)}
    }
    let p = Parse {
      pmap
      Many { Parse { pmove; Optionally { "\n" }}.map{$0.0} }
    }

    do {
      let res = try p.parse(input)
      return res
    } catch {
      return ([], [])
    }
  }

  func move(map: inout [Pos: Node], pos: Pos, dir: Pos) -> Bool {
    func doMove() {
      map[pos.add(dir)] = map[pos]
      map[pos] = .empty
    }
    switch map[pos.add(dir)] {
      case .some(.empty):
        doMove()
        return true
      case .some(.wall):
        return false
      case .some(.box):
        if move(map: &map, pos: pos.add(dir), dir: dir) {
          doMove()
          return true
        } else {
          return false
        }
      case .some(.fish):
        print("Impossible: fish")
        return false
      case nil:
        print("Impossible: nil")
        return false
    }
  }

  func part1(_ input: Input) -> Part1 {
    let (arr, moves) = input
    var map: [Pos: Node] = [:]
    var fishPos: Pos = Pos(x: 0, y: 0)
    for (y, row) in arr.enumerated() {
      for (x, n) in row.enumerated() {
        map[Pos(x:x,y:y)] = n
        if n == .fish {
          fishPos = Pos(x:x,y:y)
        }
      }
    }
    for m in moves {
      if move(map: &map, pos: fishPos, dir: m) {
        fishPos = fishPos.add(m)
      }
    }
    return map.map{(p,n) in
      if n == .box {
        return p.y*100+p.x
      } else {
        return 0
      }
    }.reduce(0, +)
  }

  func canMove2(map: [Pos: Character], pos: Pos, dir: Pos) -> Bool {
    switch map[pos] {
      case "]":
        return canMove2(map: map, pos: Pos(x:pos.x-1, y:pos.y), dir: dir)
      case "[":
        switch dir {
          case Pos(x:1, y: 0):
            return canMove2(map: map, pos: Pos(x:pos.x+2, y:pos.y), dir: dir)
          case Pos(x:-1, y: 0):
            return canMove2(map: map, pos: Pos(x:pos.x-1, y:pos.y), dir: dir)
          default:
            return canMove2(map: map, pos: pos.add(dir), dir: dir) && canMove2(map: map, pos: pos.add(Pos(x:1,y:0)).add(dir), dir: dir)
        }
      case "@":
        return canMove2(map: map, pos: pos.add(dir), dir: dir)
      case ".":
        return true
      case "#":
        return false
      default:
        print("Impossible: Unknown character or unknown position")
        return false
    }
  }

  func move2(map: inout [Pos: Character], pos: Pos, dir: Pos) -> Bool {
    if canMove2(map: map, pos: pos, dir: dir) {
      switch map[pos] {
        case "]":
          return move2(map: &map, pos: Pos(x:pos.x-1, y:pos.y), dir: dir)
        case "[":
          switch dir {
            case Pos(x:1, y: 0):
              let _ = move2(map: &map, pos: Pos(x:pos.x+2, y:pos.y), dir: dir)
              map[Pos(x:pos.x+2,y:pos.y)] = "]"
              map[Pos(x:pos.x+1,y:pos.y)] = "["
              map[pos] = "."
              return true
            case Pos(x:-1, y: 0):
              let _ = move2(map: &map, pos: pos.add(dir), dir: dir)
              map[pos.add(dir)] = "["
              map[pos] = "]"
              map[pos.add(Pos(x:1,y:0))] = "."
              return true
            default:
              let _ = move2(map: &map, pos: pos.add(dir), dir: dir)
              let _ = move2(map: &map, pos: pos.add(dir).add(Pos(x:1,y:0)), dir: dir)
              map[pos.add(dir)] = "["
              map[pos] = "."
              map[pos.add(dir).add(Pos(x:1,y:0))] = "]"
              map[pos.add(Pos(x:1,y:0))] = "."
              return true
          }
        case "@":
          let _ = move2(map: &map, pos: pos.add(dir), dir: dir)
          map[pos.add(dir)] = "@"
          map[pos] = "."
          return true
        default:
          return true
      }
    } else {
      return false
    }
  }

  func part2(_ input: Input) -> Part2 {
    let (arr, moves) = input
    var map: [Pos: Character] = [:]
    var fishPos = Pos(x:0,y:0)
    for (y, row) in arr.enumerated() {
      for (x, n) in row.enumerated() {
        switch n {
          case .box:
            map[Pos(x:x*2,y:y)] = "["
            map[Pos(x:x*2+1,y:y)] = "]"
          case .wall:
            map[Pos(x:x*2,y:y)] = "#"
            map[Pos(x:x*2+1,y:y)] = "#"
          case .fish:
            map[Pos(x:x*2,y:y)] = "@"
            map[Pos(x:x*2+1,y:y)] = "."
            fishPos = Pos(x:x*2,y:y)
          case .empty:
            map[Pos(x:x*2,y:y)] = "."
            map[Pos(x:x*2+1,y:y)] = "."
        }
      }
    }

    for m in moves {
      if move2(map: &map, pos: fishPos, dir: m) {
        fishPos = fishPos.add(m)
      }
    }

    return map.map{(p,n) in
      if n == "[" {
        return p.y*100+p.x
      } else {
        return 0
      }
    }.reduce(0, +)
  }
}
