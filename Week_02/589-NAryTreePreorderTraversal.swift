import Foundation

/*
 给定一个 N 叉树，返回其节点值的前序遍历。
 https://leetcode-cn.com/problems/n-ary-tree-preorder-traversal/description/
*/

class Solution {
    
    /// 递归写法
    func preorder(_ root: Node?) -> [Int] {
        if root == nil { return [] }
        var res = [root!.val]
        for i in 0..<root!.children.count {
            res += preorder(root!.children[i])
        }
        return res
    }
    
    /// 迭代写法
    func preorder1(_ root: Node?) -> [Int] {
        guard let root = root else { return [] }
        var result: [Int] = []
        var stack: [Node] = [root]
        while !stack.isEmpty {
            let current = stack.removeLast()
            stack.append(contentsOf: current.children.reversed())
            result.append(current.val)
        }
        return result
    }
    
    /// 迭代写法2
    func preorder2(_ root: Node?) -> [Int] {
        guard let root = root else { return [] }
        var result: [Int] = []
        var stack: [(Node, Bool)] = [(root, false)]
        while !stack.isEmpty {
            let (current, isReached) = stack.removeLast()
            if isReached {
                result.append(current.val)
            } else {
                let children = current.children.reversed().map({ ($0, false) })
                stack.append(contentsOf: children)
                stack.append((current, true))
            }
        }
        return result
    }
    
}