import Parsing

class Day17: Day {

  typealias Input = (Int, Int, Int, [Int])

  func parse(_ input: String) -> Input {
    let p = Parse {
      "Register A: "
      Int.parser()
      "\nRegister B: "
      Int.parser()
      "\nRegister C: "
      Int.parser()
      "\n\nProgram: "
      Many {
        Int.parser()
      } separator: {
        ","
      }
    }

    do {
      let res = try p.parse(input)
      return res
    } catch {
      return (0, 0, 0, [])
    }
  }

  typealias Part1 = String

  func runProgram(_ input: Input) -> [Int] {
    var (regA, regB, regC, program) = input
    var pointer = 0
    func getCombo(_ pointer: Int) -> Int {
      if regA < 0 || regB < 0 || regC < 0 {
      }
      if pointer >= 0 && pointer <= 3 {
        return pointer
      } else if pointer == 4 {
        return regA
      } else if pointer == 5 {
        return regB
      } else if pointer == 6 {
        return regC
      } else {
        return -1
      }
    }
    var output: [Int] = []
    while pointer < program.count {
      let op = program[pointer]
      switch op {
      case 0:
        regA = regA / pow(2, getCombo(program[pointer + 1]))
      case 1:
        regB = regB ^ program[pointer + 1]
      case 2:
        regB = getCombo(program[pointer + 1]) % 8
      case 3:
        if regA != 0 {
          pointer = program[pointer + 1] - 2
        }
      case 4:
        regB = regB ^ regC
      case 5:
        let v = getCombo(program[pointer + 1]) % 8
        output.append(v)
      case 6:
        regB = regA / pow(2, getCombo(program[pointer + 1]))
      case 7:
        regC = regA / pow(2, getCombo(program[pointer + 1]))
      default: ()
      }
      pointer += 2
    }
    return output
  }

  func part1(_ input: Input) -> Part1 {
    let output = runProgram(input)
    return output.map { i in String(i) }.joined(separator: ",")
  }

  func part2(_ input: Input) -> Part2 {
    let (_, regB, regC, program) = input

    var answer = 0
    stepLoop: for i in 0...program.count - 1 {
      answer = answer << 3
      for a in 0...7 {
        let res = runProgram((answer + a, regB, regC, program))
        if res[0...res.count - 1] == program[program.count - i - 1...program.count - 1] {
          answer += a
          continue stepLoop
        }
      }
    }
    return answer
  }
}
