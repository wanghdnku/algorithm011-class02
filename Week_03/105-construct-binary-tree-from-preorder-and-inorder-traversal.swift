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
    
    // 思路
    // preorder 第一个是root节点 [root,[左],[右]]
    // inorder 中root节点左侧的是左子树，右侧是右子树 [[左],root,[右]]
    func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
        if preorder.count == 0 {
            return nil
        }
        // 空间换时间
        // 优化查找速度
        var map = [Int: Int]()
        for i in 0..<inorder.count {
            map[inorder[i]] = i
        }
        return buildTree(preorder, 0, preorder.count - 1, inorder, 0, inorder.count - 1, map)
    }
    
    func buildTree(_ preorder: [Int], _ pb: Int, _ pe: Int, _ inorder: [Int], _ ib: Int, _ ie: Int, _ map: [Int: Int]) -> TreeNode? {
        if pe < pb {
            return nil
        }
        let node = TreeNode(preorder[pb])
        let indexInorder = map[preorder[pb]] ?? ib
        let indexPreorder = pb + indexInorder - ib
        node.left = buildTree(preorder, pb + 1, indexPreorder, inorder, ib, indexInorder - 1, map)
        node.right = buildTree(preorder, indexPreorder + 1, pe, inorder, indexInorder + 1, ie, map)
        return node
    }
    
}