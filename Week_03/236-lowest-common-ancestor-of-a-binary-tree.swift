/**
 * Definition for a binary tree node.
 * public class TreeNode {
 *     public var val: Int
 *     public var left: TreeNode?
 *     public var right: TreeNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.left = nil
 *         self.right = nil
 *     }
 * }
 */

class Solution {

    // 递归
    func lowestCommonAncestor0(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil || p === root || q === root { return root }

        let left = lowestCommonAncestor(root?.left, p, q)
        let right = lowestCommonAncestor(root?.right, p, q)

        if left == nil { return right }
        if right == nil { return left }
        return root
    }

    // 非递归
    func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
        if root == nil || p == nil || q == nil { return root }
        hashTable[root!.val] = nil
        dfs(root)

        var p: TreeNode? = p
        var q: TreeNode? = q
        while p != nil {
            exist[p!.val] = true
            if let pp = hashTable[p!.val] {
                p = pp
            } else {
                p = nil
            }
        }

        while q != nil {
            if let isExist = exist[q!.val], isExist {
                return q
            }
            if let qq = hashTable[q!.val] {
                q = qq
            } else {
                q = nil
            }
        }
        return nil
    }
    var exist: [Int : Bool] = [:]
    var hashTable: [Int : TreeNode?] = [:]
    func dfs(_ root: TreeNode?) {
        guard let root = root else { return }
        if root.left != nil {
            hashTable[root.left!.val] = root
            dfs(root.left!)
        }
        if root.right != nil {
            hashTable[root.right!.val] = root
            dfs(root.right!)
        }
    }
}
