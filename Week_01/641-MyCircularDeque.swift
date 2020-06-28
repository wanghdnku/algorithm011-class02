import Foundation

/**
 设计实现双端队列。
 你的实现需要支持以下操作：

 - MyCircularDeque(k)：构造函数,双端队列的大小为k。
 - insertFront()：将一个元素添加到双端队列头部。 如果操作成功返回 true。
 - insertLast()：将一个元素添加到双端队列尾部。如果操作成功返回 true。
 - deleteFront()：从双端队列头部删除一个元素。 如果操作成功返回 true。
 - deleteLast()：从双端队列尾部删除一个元素。如果操作成功返回 true。
 - getFront()：从双端队列头部获得一个元素。如果双端队列为空，返回 -1。
 - getRear()：获得双端队列的最后一个元素。 如果双端队列为空，返回 -1。
 - isEmpty()：检查双端队列是否为空。
 - isFull()：检查双端队列是否满了。
 
 [LeetCode 题目链接](https://leetcode-cn.com/problems/design-circular-deque/)
 */
class MyCircularDeque {
    
    /// 底层存储结构使用数组
    private var data: [Int]
    /// 底层依赖的 array 的大小
    private var capacity: Int {
        return data.count
    }
    
    /// 代表当前队列长度
    private var size: Int
    /// 代表 deque 开头元素的位置
    private var headIndex: Int
    /// 代表 dequeue 结尾元素的下一个位置
    private var tailIndex: Int
    

    /** Initialize your data structure here. Set the size of the deque to be k. */
    init(_ k: Int) {
        // 浪费 1 的空间，作为队列结束的标志
        data = Array(repeating: -1, count: k + 1)
        size = 0
        headIndex = 0
        tailIndex = 0
    }
    
    /** Adds an item at the front of Deque. Return true if the operation is successful. */
    func insertFront(_ value: Int) -> Bool {
        guard !isFull() else { return false }
        headIndex = (headIndex - 1 + capacity) % capacity
        data[headIndex] = value
        size += 1
        return true
    }
    
    /** Adds an item at the rear of Deque. Return true if the operation is successful. */
    func insertLast(_ value: Int) -> Bool {
        guard !isFull() else { return false }
        data[tailIndex] = value
        tailIndex = (tailIndex + 1) % capacity
        size += 1
        return true
    }
    
    /** Deletes an item from the front of Deque. Return true if the operation is successful. */
    func deleteFront() -> Bool {
        guard !isEmpty() else { return false }
        data[headIndex] = -1
        headIndex = (headIndex + 1) % capacity
        size -= 1
        return true
    }
    
    /** Deletes an item from the rear of Deque. Return true if the operation is successful. */
    func deleteLast() -> Bool {
        guard !isEmpty() else { return false }
        tailIndex = (tailIndex - 1 + capacity) % capacity
        data[tailIndex] = -1
        size -= 1
        return true
    }
    
    /** Get the front item from the deque. */
    func getFront() -> Int {
        return data[headIndex]
    }
    
    /** Get the last item from the deque. */
    func getRear() -> Int {
        return data[(tailIndex - 1 + capacity) % capacity]
    }
    
    /** Checks whether the circular deque is empty or not. */
    func isEmpty() -> Bool {
        return headIndex == tailIndex
    }
    
    /** Checks whether the circular deque is full or not. */
    func isFull() -> Bool {
        return headIndex % capacity == (tailIndex + 1) % capacity
    }
    
}


// MARK: - 辅助显示

extension MyCircularDeque: CustomStringConvertible {
    
    private func getAllElements() -> [Int] {
        var elements: [Int] = []
        for i in 0..<size {
            elements.append(data[(headIndex + i) % capacity])
        }
        return elements
    }
    
    var description: String {
        var desc = "front | " + getAllElements().map({ $0.description }).joined(separator: " | ") + " | rear\n"
        desc += "headIndex: \(headIndex), tailIndex: \(tailIndex)\n"
        desc += "data: [" + data.map({ $0.description }).joined(separator: ", ") + "]\n"
        return desc
    }
    
}


// MARK: - 测试数据

// Case 0: Normal
var circularDeque = MyCircularDeque(3)
print(circularDeque)
circularDeque.insertLast(1);                    // 返回 true
print(circularDeque)
circularDeque.insertLast(2);                    // 返回 true
print(circularDeque)
circularDeque.insertFront(3);                   // 返回 true
print(circularDeque)
circularDeque.insertFront(4);                   // 已经满了，返回 false
print(circularDeque)
circularDeque.getRear();                        // 返回 2
print(circularDeque)
circularDeque.isFull();                         // 返回 true
print(circularDeque)
circularDeque.deleteLast();                     // 返回 true
print(circularDeque)
circularDeque.insertFront(4);                   // 返回 true
print(circularDeque)
circularDeque.getFront();                       // 返回 4
print(circularDeque)

print("\n---------------------\n")

// Case 0: Normal
circularDeque = MyCircularDeque(3)
print(circularDeque)
circularDeque.insertFront(9);                   // 返回 true
print(circularDeque)
circularDeque.getRear();                        // 返回 9
print(circularDeque)
circularDeque.insertFront(9);                   // 返回 true
print(circularDeque)
circularDeque.getRear();                        // 返回 9
print(circularDeque)
circularDeque.insertLast(5);                    // 返回 true
print(circularDeque)
circularDeque.getFront();                       // 返回 9
print(circularDeque)
circularDeque.getRear();                        // 返回 5
print(circularDeque)
circularDeque.getFront();                       // 返回 9
print(circularDeque)
circularDeque.insertLast(8);                    // 返回 false
print(circularDeque)
circularDeque.deleteLast();                     // 返回 true
print(circularDeque)
circularDeque.getFront();                       // 返回 9
print(circularDeque)

print("---------------------")

// Case 0: Normal
circularDeque = MyCircularDeque(4)
circularDeque.insertFront(9);                  // 返回 true
print(circularDeque)
circularDeque.deleteLast();                    // 返回 true
print(circularDeque)
circularDeque.getRear();                       // 返回 -1
print(circularDeque)
circularDeque.getFront();                      // 返回 -1
print(circularDeque)
circularDeque.getFront();                      // 返回 -1
print(circularDeque)
circularDeque.deleteFront();                   // 返回 false
print(circularDeque)
circularDeque.insertFront(6);                  // 返回 true
print(circularDeque)
circularDeque.insertLast(5);                   // 返回 true
print(circularDeque)
circularDeque.insertFront(9);                  // 返回 true
print(circularDeque)
circularDeque.getFront();                      // 返回 9
print(circularDeque)
circularDeque.insertFront(6);                  // 返回 true
print(circularDeque)
