import Parsing

class Day5: Day {

  typealias Input = ([Ordering], [[Int]])

  struct Ordering {
    var first: Int
    var last: Int
  }

  func parse(_ input: String) -> Input {
    let orderingParser: some Parser<Substring, Ordering> = Parse {
      Int.parser()
      "|"
      Int.parser()
    }.map({ (f, l) in Ordering(first: f, last: l) })

    let pagesParser: some Parser<Substring, [Int]> = Many {
      Int.parser()
    } separator: {
      ","
    }

    let p = Parse(input: Substring.self) {
      Many {
        orderingParser
      } separator: {
        "\n"
      }
      "\n\n"
      Many {
        pagesParser
      } separator: {
        "\n"
      }
    }
    do {
      let res = try p.parse(input)
      return res
    } catch {
      return ([], [])
    }
  }

  enum Which {
    case Correct
    case Incorrect
  }

  func get_relevant_updates(input: Input, which: Which) -> [[Int]] {
    let (orderings, updates) = input
    let incorrect =
      switch which {
      case Which.Correct:
        false
      case Which.Incorrect:
        true
      }
    return updates.filter({ u in
      for i in 1...u.count - 1 {
        let lasts = orderings.filter({ $0.first == u[i] }).map({ $0.last })
        let firsts = u[0...i - 1]
        for l in lasts {
          if firsts.contains(l) {
            return incorrect
          }
        }
      }
      return !incorrect
    })
  }

  func part1(_ input: Input) -> Part1 {
    return get_relevant_updates(input: input, which: Which.Correct)
      .map({ u in u[(u.count - 1) / 2] })
      .reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    let (orderings, updates) = input

    return get_relevant_updates(input: input, which: Which.Incorrect)
      .map({ u in
        var relevants = orderings.filter({ u.contains($0.first) && u.contains($0.last) })
        var options = u
        var new_u: [Int] = []
        for _ in 0...u.count - 1 {
          for (o_index, o) in options.enumerated() {
            if (relevants).filter({ $0.last == o }).count == 0 {
              new_u.append(o)
              options.remove(at: o_index)
              relevants = relevants.filter({ $0.first != o })
              break
            }
          }
        }
        return new_u
      }).map({ u in u[(u.count - 1) / 2] })
      .reduce(0, +)
  }
}
