import Foundation

/**
 给定一个由整数组成的非空数组所表示的非负整数，在该数的基础上加一。
 最高位数字存放在数组的首位， 数组中每个元素只存储单个数字。
 你可以假设除了整数 0 之外，这个整数不会以零开头。
 */
class Solution {

    func plusOne(_ digits: [Int]) -> [Int] {
        var digits = digits
        var carry = 0
        digits[digits.count - 1] += 1
        for i in (0..<digits.count).reversed() {
            digits[i] += carry
            carry = digits[i] >= 10 ? 1 : 0
            guard carry != 0 else { return digits }
            digits[i] %= 10
            if i == 0 {
                // 简化最高位进位的写法，有助于提高执行速度
                //digits.insert(1, at: 0)
                digits[0] = 1
                digits.append(0)
            }
        }
        return digits
    }
    
}

// MARK: - 测试数据

// Case 0: Normal
var digits = [1,2,3]
var result = Solution().plusOne(digits)
print(result)

// Case 1:
digits = [0]
result = Solution().plusOne(digits)
print(result)

// Case 2:
digits = [1,2,9]
result = Solution().plusOne(digits)
print(result)

// Case 3:
digits = [1,9,9]
result = Solution().plusOne(digits)
print(result)

// Case 4:
digits = [9,9,9]
result = Solution().plusOne(digits)
print(result)

// Case 5:
digits = [0,0,0]
result = Solution().plusOne(digits)
print(result)
