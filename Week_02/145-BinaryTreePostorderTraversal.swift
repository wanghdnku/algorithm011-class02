import Foundation

/*
 给定一个二叉树，返回它的 后序 遍历。
 https://leetcode-cn.com/problems/binary-tree-postorder-traversal/
*/

class Solution {
    
    /// 递归写法
    func postorderTraversal(_ root: TreeNode?) -> [Int] {
        guard root != nil else { return [] }
        return postorderTraversal(root!.left) + postorderTraversal(root!.right) + [root!.val]
    }
    
    /// 利用栈的后序遍历非递归写法
    func postorderTraversal1(_ root: TreeNode?) -> [Int] {
        guard root != nil else { return [] }
        var result: [Int] = []
        var stack: [TreeNode] = [root!]
        while !stack.isEmpty {
            let current = stack.removeLast()
            result.append(current.val)
            if let left = current.left { stack.append(left) }
            if let right = current.right { stack.append(right) }
        }
        return result.reversed()
    }
    
    /// 模拟系统调用栈的 DFS 统一写法
    func postorderTraversal2(_ root: TreeNode?) -> [Int] {
        typealias TreeNodeState = (node: TreeNode, isReached: Bool)
        guard root != nil else { return [] }
        var result: [Int] = []
        var callStack: [TreeNodeState] = [(root!, false)]
        while !callStack.isEmpty {
            let (currentNode, isReached) = callStack.removeLast()
            if isReached {
                result.append(currentNode.val)
            } else {
                callStack.append((currentNode, true))
                if let rightNode = currentNode.right {
                    callStack.append((rightNode, false))
                }
                if let leftNode = currentNode.left {
                    callStack.append((leftNode, false))
                }
            }
        }
        return result
    }
    
}

// MARK: - 数据结构

/// Definition for a binary tree node.
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}