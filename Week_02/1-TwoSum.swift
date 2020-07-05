import Foundation

/*
 给定一个整数数组 nums 和一个目标值 target，请你在该数组中找出和为目标值的那 两个 整数，并返回他们的数组下标。
 你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。
 https://leetcode-cn.com/problems/two-sum/description/
*/
 
class Solution {
    
    /// 使用双指针夹逼求解
    func twoSum0(_ nums: [Int], _ target: Int) -> [Int] {
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
    
    /// 使用哈希表存储值对应的 index
    func twoSum1(_ nums: [Int], _ target: Int) -> [Int] {
        var dic: [Int: Int] = [:]
        for (index, number) in nums.enumerated() {
            dic[number] = index
        }
        for (index, number) in nums.enumerated() {
            if let place = dic[target - number], place != index {
                return [index, place]
            }
        }
        return []
    }
    
    /// 哈希表解法优化，遍历一次完成
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dic: [Int: Int] = [:]
        for (index, number) in nums.enumerated() {
            if let place = dic[target - number] {
                return [place, index]
            } else {
                dic[number] = index
            }
        }
        return []
    }
    
}