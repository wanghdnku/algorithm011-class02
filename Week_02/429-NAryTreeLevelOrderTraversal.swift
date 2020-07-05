import Foundation

/*
 给定一个 N 叉树，返回其节点值的层序遍历。 (即从左到右，逐层遍历)。
 https://leetcode-cn.com/problems/n-ary-tree-level-order-traversal/
*/

class Solution {
    
    func levelOrder(_ root: Node?) -> [[Int]] {
        guard root != nil else { return [] }
        var result: [[Int]] = []
        var queue: [Node] = [root!]
        while !queue.isEmpty {
            var levelResult: [Int] = []
            for _ in 0..<queue.count {
                let node = queue.removeFirst()
                levelResult.append(node.val)
                queue.append(contentsOf: node.children)
            }
            result.append(levelResult)
        }
        return result
    }
    
}

// MARK: - 数据结构

/// Definition for a Node.
public class Node {
    public var val: Int
    public var children: [Node]
    public init(_ val: Int) {
        self.val = val
        self.children = []
    }
}