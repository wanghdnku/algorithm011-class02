class Solution {

    func permute(_ nums: [Int]) -> [[Int]] {
        var res = [[Int]]()
        var track = [Int]()
        var used = [Bool](repeating: false, count: nums.count)
        backtrack(nums, track: &track, used: &used, res: &res)
        return res
    }

    func backtrack(_ nums: [Int], track: inout [Int], used: inout [Bool] ,res: inout [[Int]]) {
        if track.count == nums.count {
            let r = track
            res.append(r)
            return
        }
        for (i, num) in nums.enumerated() {
            if used[i] {
                continue
            }
            used[i] = true
            track.append(num)
            backtrack(nums, track: &track, used: &used, res: &res)
            track.removeLast()
            used[i] = false
        }
    }
}
