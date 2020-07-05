import Foundation

/*
 给定一个二叉树，返回它的 中序 遍历。
 https://leetcode-cn.com/problems/binary-tree-inorder-traversal/
*/

class Solution {
    
    /// 递归写法
    func inorderTraversal(_ root: TreeNode?) -> [Int] {
        guard root != nil else { return [] }
        return inorderTraversal(root!.left)  + [root!.val] + inorderTraversal(root!.right)
    }
    
    /// 利用栈的中序遍历非递归写法
    func inorderTraversal1(_ root: TreeNode?) -> [Int] {
        var result: [Int] = []
        var stack: [TreeNode] = []
        var currentNode = root
        while currentNode != nil || !stack.isEmpty {
            while currentNode != nil {
                stack.append(currentNode!)
                currentNode = currentNode!.left
            }
            currentNode = stack.removeLast()
            result.append(currentNode!.val)
            currentNode = currentNode!.right
        }
        return result
    }
    
    /// 模拟系统调用栈的 DFS 统一写法
    func inorderTraversal2(_ root: TreeNode?) -> [Int] {
        typealias TreeNodeState = (node: TreeNode, isReached: Bool)
        guard root != nil else { return [] }
        var result: [Int] = []
        var callStack: [TreeNodeState] = [(root!, false)]
        while !callStack.isEmpty {
            let (currentNode, isReached) = callStack.removeLast()
            if isReached {
                result.append(currentNode.val)
            } else {
                if let rightNode = currentNode.right {
                    callStack.append((rightNode, false))
                }
                callStack.append((currentNode, true))
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