import Foundation

/**
 给定一个数组，将数组中的元素向右移动 k 个位置，其中 k 是非负数。
 */
class Solution {

    func rotate(_ nums: inout [Int], _ k: Int) {
        guard nums.count > 0 else { return }
        let clippedK = k % nums.count
        reverse(&nums, from: 0, to: nums.count - 1)
        reverse(&nums, from: 0, to: clippedK - 1)
        reverse(&nums, from: clippedK, to: nums.count - 1)
    }
    
    private func reverse(_ nums: inout [Int], from fromIndex: Int, to toIndex: Int) {
        var fromIndex = fromIndex
        var toIndex = toIndex
        // 为了提升运行速度，这里不检查下标合法性，在使用时保证
        while fromIndex < toIndex {
            (nums[fromIndex], nums[toIndex]) = (nums[toIndex], nums[fromIndex])
            fromIndex += 1
            toIndex -= 1
        }
    }

}

// MARK: - 测试数据

// Case 0: Normal
var a1: [Int] = [1, 2, 3, 4, 5, 6, 7]
Solution().rotate(&a1, 4)

// Case 1: Empty array
var a2: [Int] = []
Solution().rotate(&a2, 1)

// Case 2: One element array
var a3: [Int] = [1]
Solution().rotate(&a3, 2)

// Case 3: k > array.count
var a4: [Int] = [1, 2]
Solution().rotate(&a4, 3)
