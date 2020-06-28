import Foundation

/**
 给定一个数组 nums，编写一个函数将所有 0 移动到数组的末尾，同时保持非零元素的相对顺序。
 */
class Solution {
    
    func moveZeroes(_ nums: inout [Int]) {
        var latestNonZero: Int = 0
        for i in 0..<nums.count {
            if nums[i] != 0 {
                (nums[i], nums[latestNonZero]) = (nums[latestNonZero], nums[i])
                latestNonZero += 1
            }
        }
    }
    
}

// MARK: - 测试数据

// Case 0: Normal
var nums = [0,1,0,3,12]
Solution().moveZeroes(&nums)
print(nums)

// Case 1:
nums = [0,0,0]
Solution().moveZeroes(&nums)
print(nums)

// Case 2:
nums = [0,0,0,1,2,3]
Solution().moveZeroes(&nums)
print(nums)

// Case 3:
nums = [1,2,3,0,0]
Solution().moveZeroes(&nums)
print(nums)

// Case 4:
nums = []
Solution().moveZeroes(&nums)
print(nums)

// Case 5:
nums = [1]
Solution().moveZeroes(&nums)
print(nums)

// Case 6:
nums = [0]
Solution().moveZeroes(&nums)
print(nums)
