import Foundation

/**
 给定 n 个非负整数表示每个宽度为 1 的柱子的高度图，计算按此排列的柱子，下雨之后能接多少雨水。
 https://leetcode-cn.com/problems/trapping-rain-water/
 */
class Solution {
    
    func trap(_ height: [Int]) -> Int {
        var stack: [Int] = []
        var total: Int = 0
        for i in 0..<height.count {
            while let topIndex = stack.last, height[i] > height[topIndex] {
                stack.removeLast()
                guard let lastIndex = stack.last else { break }
                let distance = i - lastIndex - 1
                let gap = min(height[i], height[lastIndex]) - height[topIndex]
                total += gap * distance
            }
            stack.append(i)
        }
        return total
    }
    
}

// MARK: - 测试数据

// Case 0: Normal
var height = [0,1,0,3,12]
let total = Solution().trap(height)
print(total)
