class Day9: Day {

  typealias Input = [Int]

  func parse(_ input: String) -> Input {
    input.map({ c in Int(String(c))! })
  }

  func part1(_ input: Input) -> Part1 {
    let totalLength = input.reduce(0, +)
    var arr: [Int?] = (0...totalLength - 1).map({ _ in nil })
    var j = 0
    for (i, n) in input.enumerated() {
      if i % 2 == 0 {
        // File
        let fileID = i / 2
        for _ in 0...n - 1 {
          arr[j] = fileID
          j += 1
        }
      } else {
        //Free space
        j += n
      }
    }
    var i = arr.count - 1
    j = 0
    while i > j {
      if arr[j] != nil {
        j += 1
        continue
      }
      if arr[i] == nil {
        i -= 1
        continue
      }
      arr[j] = arr[i]
      arr[i] = nil
    }
    return arr.enumerated().map { (i, id) in i * (id ?? 0) }.reduce(0, +)
  }

  enum Block {
    case file(Int, Int)
    case free(Int)
  }

  func part2(_ input: Input) -> Part2 {
    let blocks: [Block] = input.enumerated().map { (i, n) in
      if i % 2 == 0 {
        .file(i / 2, n)
      } else {
        .free(n)
      }
    }

    var newBlocks = blocks

    var minFreeID = 1

    for i in stride(from: blocks.count - 1, to: 0, by: -2) {
      switch blocks[i] {
      case .free(_):
        print("Impossible")
      case .file(let id, let size):
        var seenFree = false
        let newI = newBlocks.firstIndex(where: { nb in
          switch nb {
          case .file(let id2, _):
            id2 == id
          default:
            false
          }
        })!
        if newI < minFreeID {
          break
        }
        checkLoop: for j in minFreeID...newI - 1 {
          switch newBlocks[j] {
          case .free(let freeSize):
            seenFree = true
            if freeSize >= size {
              newBlocks[j] = blocks[i]
              newBlocks[newI] = .free(size)
              if freeSize > size {
                newBlocks.insert(.free(freeSize - size), at: j + 1)
              }
              break checkLoop
            }
          case .file(_, _):
            if !seenFree {
              minFreeID = j + 1
            }
          }
        }
      }
    }

    var sum = 0
    var i = 0
    for b in newBlocks {
      switch b {
      case .file(let id, let size):
        for _ in 1...size {
          sum += i * id
          i += 1
        }
      case .free(let size):
        i += size
      }
    }
    return sum
  }

  func printBlocks(_ blocks: [Block]) {
    var res = ""
    for b in blocks {
      switch b {
      case .file(let id, let size):
        for _ in 0...size - 1 {
          res += String(id)
        }
      case .free(let size):
        if size > 0 {
          for _ in 0...size - 1 {
            res += "."
          }
        }
      }
    }

    print(res)
  }
}
