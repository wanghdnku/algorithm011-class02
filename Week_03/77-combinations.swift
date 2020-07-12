class Solution {
    
    func combine(_ n: Int, _ k: Int) -> [[Int]] {
        //回溯法
        var res:[[Int]]=[]
        var arr:[Int]=[]
        backTrace(&res,&arr,k,1,n)
        return res
    }
    func backTrace(_ res:inout [[Int]],_ arr:inout [Int],_ rest:Int,_ ind:Int,_ len:Int)->Void{
        if rest == 0{
            res.append(arr)
            return
        }
        if ind > len || len-ind+1 < rest{return}
        //可以在arr中加上当前位或者不加上当前位
        backTrace(&res,&arr,rest,ind+1,len)
        arr.append(ind)
        backTrace(&res,&arr,rest-1,ind+1,len)
        arr.removeLast()
        return
    }
    
}