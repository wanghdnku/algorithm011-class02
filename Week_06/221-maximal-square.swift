// https://leetcode-cn.com/problems/maximal-square/

class Solution {
    func maximalSquare(_ matrix: [[Character]]) -> Int {
        var result: Int = 0
        guard matrix.count > 0 else {
            return result
        }
        let rowNum = matrix.count
        let colNum = matrix[0].count
        var dp = [[Int]](repeating: [Int].init(repeating: 0, count: colNum), count: rowNum)
        for i in 0..<rowNum {
            for j in 0..<colNum {
                if(matrix[i][j] == "1") {
                    if(i == 0 || j == 0) {
                        dp[i][j] = 1
                    } else {
                        dp[i][j] = min(dp[i-1][j-1], dp[i][j-1], dp[i-1][j])+1
                    }
                }
            }
        }
        
        for item in dp {
            result = max(result, item.max() ?? 0)
        }
        return result * result
        
    }
}
