import ArgumentParser
import Foundation

struct Options: ParsableArguments {
  @Option(help: ArgumentHelp("Runs day <n>.", valueName: "n"))
  var day: Int
}

let opts = Options.parseOrExit()
try await runDay(opts.day)

func executeDay<D: Day>(_ d: D, _ input: String) async {
  let parsed = d.parse(input)
  let time1 = Date()
  let res1 = await d.part1(parsed)
  let time2 = Date()
  let diff1 = time1.distance(to: time2)
  print("Part 1: ", terminator: "")
  print(res1)
  print("Part 1 took " + String(diff1) + "s")
  let res2 = await d.part2(parsed)
  let time3 = Date()
  let diff2 = time2.distance(to: time3)
  print("Part 2: ", terminator: "")
  print(res2)
  print("Part 2 took " + String(diff2) + "s")
}

func runDay(_ day: Int) async throws {
  let inputURL = Bundle.module.url(forResource: "inputs/day" + String(format: "%02d", day), withExtension: "txt")
  let input = (try String(contentsOf: inputURL!, encoding: .utf8)).trimmingCharacters(in: .whitespacesAndNewlines)
  print("======== DAY \(day) ========")
  switch day {
    case 1: await executeDay(Day1(), input)
    case 2: await executeDay(Day2(), input)
    case 3: await executeDay(Day3(), input)
    case 4: await executeDay(Day4(), input)
    case 5: await executeDay(Day5(), input)
    case 6: await executeDay(Day6(), input)
    case 7: await executeDay(Day7(), input)
    case 8: await executeDay(Day8(), input)
    case 9: await executeDay(Day9(), input)
    case 10: await executeDay(Day10(), input)
    case 11: await executeDay(Day11(), input)
    case 12: await executeDay(Day12(), input)
    case 13: await executeDay(Day13(), input)
    case 14: await executeDay(Day14(), input)
    case 15: await executeDay(Day15(), input)
    case 16: await executeDay(Day16(), input)
    case 17: await executeDay(Day17(), input)
    case 18: await executeDay(Day18(), input)
    case 19: await executeDay(Day19(), input)
    case 20: await executeDay(Day20(), input)
    case 21: await executeDay(Day21(), input)
    case 22: await executeDay(Day22(), input)
    case 23: await executeDay(Day23(), input)
    case 24: await executeDay(Day24(), input)
    case 25: await executeDay(Day25(), input)
    default:
      print("Unsupported day " + String(day))
  }
}