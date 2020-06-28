import Foundation

/**
 给定一个排序数组，你需要在 原地 删除重复出现的元素，使得每个元素只出现一次，返回移除后数组的新长度。
 不要使用额外的数组空间，你必须在 原地 修改输入数组 并在使用 O(1) 额外空间的条件下完成。
 */
class Solution {

    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        if l1 == nil && l2 != nil { return l2 }
        if l1 != nil && l2 == nil { return l1 }
        if l1 == nil && l2 == nil { return nil }
        // Create a dummy head
        let newList = ListNode()
        var currentNode = newList
        var (l1, l2) = (l1, l2)
        while l1 != nil && l2 != nil {
            if l1!.val < l2!.val {
                currentNode.next = l1
                l1 = l1?.next
                currentNode = currentNode.next!
            } else {
                currentNode.next = l2
                l2 = l2?.next
                currentNode = currentNode.next!
            }
        }
        if l1 != nil { currentNode.next = l1 }
        if l2 != nil { currentNode.next = l2 }
        // Discard dummy head
        return newList.next
    }
    
}

// MARK: - 基础数据结构

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
}

extension ListNode: CustomStringConvertible {
    public var description: String {
        var vals: [Int] = []
        var currentNode = self
        while true {
            vals.append(currentNode.val)
            guard let nextNode = currentNode.next else { break }
            currentNode = nextNode
        }
        return vals.map({ "\($0)" }).joined(separator: "->")
    }
}

// MARK: - 测试数据

// Case 0: Normal
var l1_0: ListNode? = ListNode(1, ListNode(2, ListNode(4)))
var l2_0: ListNode? = ListNode(1, ListNode(3, ListNode(4)))
let l3_0: ListNode? = Solution().mergeTwoLists(l1_0, l2_0)
print(l3_0!)

// Case 1: Normal
var l1_1: ListNode? = ListNode(1, ListNode(2, ListNode(4)))
var l2_1: ListNode? = ListNode(-5)
let l3_1: ListNode? = Solution().mergeTwoLists(l1_1, l2_1)
print(l3_1!)

// Case 2: Empty list
var l1_2: ListNode? = ListNode(1, ListNode(2, ListNode(4)))
var l2_2: ListNode? = nil
let l3_2: ListNode? = Solution().mergeTwoLists(l1_2, l2_2)
print(l3_2!)

// Case 3: One element array
var l1_3: ListNode? = ListNode(1)
var l2_3: ListNode? = ListNode(3)
let l3_3: ListNode? = Solution().mergeTwoLists(l1_3, l2_3)
print(l3_3!)
