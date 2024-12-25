import Foundation
import Parsing

class Day24: Day {
  enum Op {
    case or
    case and
    case xor
  }
  
  typealias Gate = (String, Op, String, String)
  typealias Input = ([(String, Int)], [Gate])

  func parse(_ input: String) -> Input {
    let initParser: some Parser<Substring, (String, Int)> = Parse {
      Prefix { $0 != ":" }.map { String($0) }
      ": "
      Int.parser()
    }
    let opParser: some Parser<Substring, Op> = OneOf {
      "OR".map { .or }
      "AND".map { .and }
      "XOR".map { .xor }
    }
    let gateParser: some Parser<Substring, (String, Op, String, String)> = Parse {
      Prefix { $0 != " " }.map { String($0) }
      " "
      opParser
      " "
      Prefix { $0 != " " }.map { String($0) }
      " -> "
      Prefix { $0 != "\n" }.map { String($0) }
    }
    let p = Parse {
      Many {
        initParser
      } separator: {
        "\n"
      }
      "\n\n"
      Many {
        gateParser
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

  func part1(_ input: Input) -> Part1 {
    let (inits, gates) = input
    var state: [String: Int] = [:]
    for (s, n) in inits {
      state[s] = n
    }
    var gateDict: [String: [Gate]] = [:]
    for g in gates {
      let (s1, _, s2, _) = g
      gateDict[s1] = (gateDict[s1] ?? []) + [g]
      gateDict[s2] = (gateDict[s2] ?? []) + [g]
    }
    var queue = gates.filter { (s1, _, s2, _) in
      state.keys.contains(s1) && state.keys.contains(s2)
    }
    while let g = queue.popLast() {
      let (s1, op, s2, s3) = g
      let v1 = state[s1]!
      let v2 = state[s2]!
      let v3 =
        switch op {
        case .and:
          v1 & v2
        case .or:
          v1 | v2
        case .xor:
          v1 ^ v2
        }
      state[s3] = v3
      if gateDict[s3] != nil {
        let newRules = gateDict[s3]!.filter { g2 in state[g2.0] != nil && state[g2.2] != nil }
        queue.insert(contentsOf: newRules, at: 0)
      }
    }
    let resultKeys = state.keys.filter { s in s.first == "z" }.sorted().reversed()
    let results = resultKeys.map { s in state[s]! }
    return results.reduce(0, { (acc, x) in (acc << 1) | x })
  }

  struct Branch {
    let s1: Tree
    let s2: Tree
    let op: Op

    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.op == rhs.op
        && ((lhs.s1 == rhs.s1 && lhs.s2 == rhs.s2)
          || (lhs.s1 == rhs.s2 && lhs.s2 == rhs.s1))
    }
  }

  enum Tree {
    indirect case branch(Branch)
    case leaf(String)

    static func == (lhs: Self, rhs: Self) -> Bool {
      switch (lhs, rhs) {
      case (.branch(let b1), .branch(let b2)):
        b1 == b2
      case (.leaf(let s1), .leaf(let s2)):
        s1 == s2
      default:
        false
      }
    }
  }

  func findOutput(_ t: Branch) -> String {
    if t.op == .xor {
      if case Tree.leaf(let x) = t.s1 {
        if case Tree.leaf(_) = t.s2 {
          let num = x.dropFirst()
          return "XOR right before output \(num)"
        }
      }
      if case Tree.branch(let b1) = t.s1 {
        if case Tree.branch(let b2) = t.s2 {
          let o1 = findOutput(b1)
          let o2 = findOutput(b2)
          if o1.starts(with: "XOR right before output ")
            || o2.starts(with: "XOR right before output ")
          {
            let bi = biggestInput(.branch(t))
            return "OUTPUT z\(String(format:"%02d", bi))"
          }
        }
      }
    } else if t.op == .or {
      let bi = biggestInput(.branch(t))
      let num = String(format: "%02d", bi)
      return "OR right before output \(num)"
    } else {
      if case Tree.leaf(let x) = t.s1 {
        if case Tree.leaf(_) = t.s2 {
          let num = String(format: "%02d", Int(x.dropFirst())! + 1)
          return "AND before OR before output \(num)"
        }
      } else {
        let bi = biggestInput(.branch(t))
        return "AND with bi \(bi)"
      }
    }
    return "UNKNOWN"
  }

  func idealTree(_ i: Int) -> Branch {
    if i == 0 {
      return Branch(
        s1: .leaf("x00"),
        s2: .leaf("y00"),
        op: .xor
      )
    }
    if i == 1 {
      let b0: Branch =
        switch idealTree(i - 1) {
        case let b:
          Branch(
            s1: b.s1,
            s2: b.s2,
            op: .and
          )
        }
      let b1: Branch = Branch(
        s1: .leaf("x01"),
        s2: .leaf("y01"),
        op: .xor
      )
      return Branch(
        s1: .branch(b0),
        s2: .branch(b1),
        op: .xor
      )
    }

    let prev = idealTree(i - 1)
    let prevand: Branch =
      switch prev {
      case let b:
        Branch(s1: b.s1, s2: b.s2, op: .and)
      }
    let prevnum = String(format: "%02d", i - 1)
    let both: Tree = .branch(Branch(s1: .leaf("x" + prevnum), s2: .leaf("y" + prevnum), op: .and))
    let added: Tree = .branch(Branch(s1: both, s2: .branch(prevand), op: .or))
    let ownnum = String(format: "%02d", i)
    let own: Tree = .branch(Branch(s1: .leaf("x\(ownnum)"), s2: .leaf("y\(ownnum)"), op: .xor))
    let res: Branch = Branch(s1: own, s2: added, op: .xor)

    return res
  }

  func buildTree(_ s: String, _ gates: [Gate]) -> Tree {
    var gateDict: [String: Gate] = [:]
    for g in gates {
      let (_, _, _, s2) = g
      gateDict[s2] = g
    }

    func stringToTree(_ s2: String) -> Tree {
      let pred = gateDict[s2]
      if pred == nil {
        return .leaf(s2)
      } else {
        return .branch(
          Branch(
            s1: stringToTree(pred!.0),
            s2: stringToTree(pred!.2),
            op: pred!.1
          ))
      }
    }

    return stringToTree(s)
  }

  func biggestInput(_ t: Tree) -> Int {
    switch t {
    case .leaf(let s):
      return Int(s.dropFirst())!
    case .branch(let b):
      return max(biggestInput(b.s1), biggestInput(b.s2))
    }
  }

  func part2(_ input: Input) -> Part2 {
    let (_, gates) = input
    var ideals: [String: Branch] = [:]
    var actuals: [String: Tree] = [:]
    print(
      "Go to https://draw.io and select Arrange->Insert->Advanced->From Text. Select \"Horizontal Flow\" and paste the following lines:\n\n"
    )
    var i = 0
    for g in gates {
      let (s1, op, s2, s3) = g
      let opS =
        switch op {
        case .and:
          "AND"
        case .or:
          "OR"
        case .xor:
          "XOR"
        }
      let opName = "\(opS)\(i)"
      print("\(s1)->\(opName)")
      print("\(s2)->\(opName)")
      print("\(opName)->\(s3)")
      i += 1

      actuals[s3] = buildTree(s3, gates)
    }
    print("\n\n")

    for i in 0...44 {
      // This doesn't check outputs 45 and 46 because they're different.
      // I didn't need them for my input luckily
      let num = String(format: "%02d", i)
      let z = "z\(num)"
      ideals[z] = idealTree(i)
      if !(.branch(ideals[z]!) == actuals[z]!) {
        print("WRONG ", i)
      }
    }

    func printOutput(_ s: String) {
      if case .branch(let b) = actuals[s] {
        print(s, findOutput(b))
      }
    }

    // Print what roles I think certain nodes should have. Manually crosscheck if this is right in the input
    printOutput("z37")
    printOutput("rrn")
    printOutput("z38")

    return 0
  }
}
