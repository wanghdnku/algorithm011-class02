import Foundation

/**
 给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。

 你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。
 */
class Solution {
    
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var sortedNums: [(index: Int, value: Int)] = []
        for (i, v) in nums.enumerated() {
            sortedNums.append((i, v))
        }
        sortedNums.sort(by: { $0.value < $1.value })
        var lowerBound = 0
        var upperBound = sortedNums.count - 1
        print(sortedNums)
        while lowerBound < upperBound {
            if sortedNums[lowerBound].value + sortedNums[upperBound].value < target {
                lowerBound += 1
            } else if sortedNums[lowerBound].value + sortedNums[upperBound].value > target {
                upperBound -= 1
            } else {
                return [sortedNums[lowerBound].index, sortedNums[upperBound].index].sorted()
            }
        }
        return []
    }
    
}

// MARK: - 测试数据

// Case 0: Normal
var nums = [2, 7, 11, 15]
let indices = Solution().twoSum(nums, 9)
print(indices)
