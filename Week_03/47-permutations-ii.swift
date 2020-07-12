class Solution {

    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var track = [Int]()
        var used = [Bool](repeating: false, count: nums.count)
        var res = [[Int]]()
        backtrack(nums.sorted(), track: &track, used: &used, res: &res)
        return res
    }

    func backtrack(_ nums: [Int], track: inout [Int], used: inout [Bool], res: inout [[Int]]) {
        if track.count == nums.count {
            let r = track
            res.append(r)
            return
        }
        for (index, num) in nums.enumerated() {
            if used[index] {
                continue
            }
            if index > 0 && num == nums[index - 1] && !used[index - 1] {
                continue
            }
            used[index] = true
            track.append(num)
            backtrack(nums, track: &track, used: &used, res: &res)
            track.removeLast()
            used[index] = false
        }
    }
}
