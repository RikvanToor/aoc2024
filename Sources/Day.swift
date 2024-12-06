protocol Day {
  associatedtype Input = String
  func parse(_ input: String) -> Input
  associatedtype Part1 = Int
  func part1(_ input: Input) async -> Part1
  associatedtype Part2 = Int
  func part2(_ input: Input) async -> Part1
}