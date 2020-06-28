import Foundation

/**
 给定一个排序数组，你需要在 原地 删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。
 不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。
 */
class Solution {
    
    func removeDuplicates0(_ nums: inout [Int]) -> Int {
        guard nums.count > 1 else { return nums.count }
        var nonDupIndex: Int = 1
        var dupNum = nums[0]
        for currentIndex in 1..<nums.count where nums[currentIndex] != dupNum {
            dupNum = nums[currentIndex]
            nums[nonDupIndex] = dupNum
            nonDupIndex += 1
        }
        return nonDupIndex
    }
    
    // 为了节省内存，删除 dupNum 临时变量
    func removeDuplicates1(_ nums: inout [Int]) -> Int {
        guard nums.count > 1 else { return nums.count }
        var nonDupIndex: Int = 1
        for currentIndex in 1..<nums.count where nums[currentIndex] != nums[nonDupIndex - 1] {
            nums[nonDupIndex] = nums[currentIndex]
            nonDupIndex += 1
        }
        return nonDupIndex
    }
    
    // 使用 1..<num.count 的方法，生成了一个长度 n 的数组。使用 while 方法代替，节省内存
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        guard nums.count > 1 else { return nums.count }
        var nonDupIndex: Int = 1
        var currentIndex = 1
        while currentIndex < nums.count {
            if nums[currentIndex] != nums[nonDupIndex - 1] {
                nums[nonDupIndex] = nums[currentIndex]
                nonDupIndex += 1
            }
            currentIndex += 1
        }
        return nonDupIndex
    }
    
}

// MARK: - 测试数据

// Case 0: Normal
var a0: [Int] = [0,0,1,1,1,2,2,3,3,4]
Solution().removeDuplicates(&a0)
print(a0)

// Case 1: Normal
var a1: [Int] = [0,0,1,1,1,2,2,3,3,4,5,5,5]
Solution().removeDuplicates(&a1)
print(a1)

// Case 2: Empty array
var a2: [Int] = []
Solution().removeDuplicates(&a2)
print(a2)

// Case 3: One element array
var a3: [Int] = [1]
Solution().removeDuplicates(&a3)
print(a3)

// Case 4: No duplicate
var a4: [Int] = [1,2,3,4,5]
Solution().removeDuplicates(&a4)
print(a4)