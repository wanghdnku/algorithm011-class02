import Foundation

/*
 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
 https://leetcode-cn.com/problems/valid-anagram/description/
*/
 
class Solution {
    
    /// 直接排序比较
    func isAnagram0(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        return s.sorted() == t.sorted()
    }
    
    /// 双指针法
    func isAnagram(_ s: String, _ t: String) -> Bool {
        guard s.count == t.count else { return false }
        var smap: [Character: Int] = [:]
        for c in s {
            smap[c] = (smap[c] ?? 0) + 1
        }
        for c in t {
            if let count = smap[c] {
                smap[c] = (count == 1) ? nil : (count - 1)
            }
        }
        return smap.isEmpty
    }
}