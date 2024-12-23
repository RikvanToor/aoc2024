class Day22: Day {

  typealias Input = [Int]

  func parse(_ input: String) -> Input {
    input.split(separator: "\n").map {l in Int(l)!}
  }

  func steps(_ n: Int) -> Int {
    let n1 = ((n * 64) ^ n) & 16777215
    let n2 = ((n1 / 32) ^ n1) & 16777215
    return ((n2 * 2048) ^ n2) & 16777215
  }

  func run(_ secret: Int, _ times: Int) -> Int {
    if times == 1 {
      return steps(secret)
    }
    return run(steps(secret), times - 1)
  }

  func part1(_ input: Input) -> Part1 {
    input.map{ i in run(i, 2000)}.reduce(0, +)
  }

  func part2(_ input: Input) -> Part2 {
    let seqsToPrices = input.map { n in
      var nums = Array(0...2000)
      var prices = Array (0...2000)
      var changes = Array(0...1999)
      var seqs: [Seq: Int] = [:]
      nums[0] = n
      prices[0] = n % 10
      for i in 1...2000 {
        nums[i] = steps(nums[i-1])
        prices[i] = nums[i] % 10
        changes[i-1] = prices[i] - prices[i-1]
      }

      for i in 0...1996 {
        let seq = Seq(n1: changes[i], n2: changes[i+1], n3: changes[i+2], n4: changes[i+3])
        let price = prices[i+4]
        if seqs[seq] == nil {
          seqs[seq] = price
        }
      }
      return seqs
    }

    let allSeqs = Set(seqsToPrices.flatMap{seq in seq.keys})
    return allSeqs.map {s in seqsToPrices.map{dict in dict[s] ?? 0}.reduce(0, +)}.max() ?? 0
  }

  struct Seq: Hashable {
    let n1: Int
    let n2: Int
    let n3: Int
    let n4: Int
  }

}
