import Foundation

/**
 给你两个有序整数数组 nums1 和 nums2，请你将 nums2 合并到 nums1 中，使 nums1 成为一个有序数组。

 说明:
 初始化 nums1 和 nums2 的元素数量分别为 m 和 n 。
 你可以假设 nums1 有足够的空间（空间大小大于或等于 m + n）来保存 nums2 中的元素。
 */
class Solution {
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        if n <= 0 {
            return
        }
        if m <= 0 {
            for i in 0..<n { nums1[i] = nums2[i] }
            return
        }
        var tail1 = m - 1
        var tail2 = n - 1
        var tailSum = m + n - 1
        while tail1 >= 0 && tail2 >= 0 {
            if nums1[tail1] > nums2[tail2] {
                nums1[tailSum] = nums1[tail1]
                tail1 -= 1
            } else {
                nums1[tailSum] = nums2[tail2]
                tail2 -= 1
            }
            tailSum -= 1
        }
        if tail1 < 0 {
            if tail2 < 0 { return }
            for i in (0...tail2).reversed() {
                nums1[i] = nums2[i]
            }
        }
    }
}

// MARK: - 测试数据

// Case 0: Normal
var nums1 = [1,2,3,0,0,0]
var nums2 = [2,5,6]
Solution().merge(&nums1, 3, nums2, 3)
print(nums1)

// Case 1:
nums1 = [1]
nums2 = []
Solution().merge(&nums1, 1, nums2, 0)
print(nums1)

// Case 2:
nums1 = [0]
nums2 = [1]
Solution().merge(&nums1, 0, nums2, 1)
print(nums1)

// Case 3:
nums1 = []
nums2 = []
Solution().merge(&nums1, 0, nums2, 0)
print(nums1)

// Case 4:
nums1 = [1, 0]
nums2 = [2]
Solution().merge(&nums1, 1, nums2, 1)
print(nums1)

// Case 5:
nums1 = [2, 0]
nums2 = [1]
Solution().merge(&nums1, 1, nums2, 1)
print(nums1)

// Case 6:
nums1 = [0,0,0,0,0,0]
nums2 = [2,5,6]
Solution().merge(&nums1, 0, nums2, 3)
print(nums1)
