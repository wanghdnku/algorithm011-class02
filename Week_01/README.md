# Week01 学习笔记

## 列表、栈和队列

### 1. 列表（List）

首先，用协议规范一个列表的操作：

```swift
protocol List {
    associatedtype T: Equatable

    var isEmpty: Bool { get }

    // 访问
    func getFirst() -> T?
    func getLast() -> T?
    func getElement(at index: Int) -> T?
    func setElement(_ element: T, at index: Int) -> Bool

    // 查找
    func contains(_ element: T) -> Bool

    // 插入
    func addFirst(_ element: T) -> Bool
    func addLast(_ element: T) -> Bool
    func insert(_ element: T, at destIndex: Int) -> Bool

    // 删除
    func removeFirst() -> T?
    func removeLast() -> T?
    func remove(at index: Int) -> T?
}
```

列表的操作涵盖了常用的访问、查找、插入、删除，以及判空操作。

#### 1.1 数组（ArrayList）

> 数组（Array）是一种**线性表**数据结构。它用一组**连续的内存空间**，来存储一组具有**相同类型**的数据。

数组的定义强调两点：

1. 线性表（Linear List）：就是数据排成像一条线一样的结构。每个线性表上的数据最多只有前和后两个方向。
2. 连续空间+相同类型：这两个约束，决定了数组可以通过内存中的初始地址加上偏移量，计算出数组中任意元素的存储位置。也就是“随机访问”

下面使用 Swift 的基本数据结构 Array 来实现一个 ArrayList：

> NOTE：由于 Swift 的 Array 实际上封装了对一个基础数组的各种操作，也实现了数组的动态扩容。但是在这里，我们把它当作最基础的只有数组使用，避免使用 Array 中封装好的方法。

首先定义一个数组

```swift

public class ArrayList<T> {

    private var data: [T?]
    private(set) var size: Int

    /// 创建一个数组
    /// - Parameter initialCapacity: 数组初始容量，默认为 10
    init(initialCapacity: Int = 10) {
        self.data = Array(repeating: nil, count: initialCapacity)
        self.size = 0
    }

    /// ArrayList 是否为空
    var isEmpty: Bool {
        return size == 0
    }

    /// ArrayList 的当前容量
    var capacity: Int {
        return data.count
    }
}
```

当创建 ArrayList 时，可以指定一个初始大小，随着对 ArrayList 的操作，这个大小将会动态变化。

接下来实现前面定义的 List 协议：

首先是访问：

```swift
    func getFirst() -> T? {
        return getElement(at: 0)
    }

    func getLast() -> T? {
        return getElement(at: size - 1)
    }

    func getElement(at index: Int) -> T? {
        guard index >= 0, index < size else {
            return nil
        }
        return data[index]
    }

    func setElement(_ element: T, at index: Int) -> Bool {
        guard index >= 0, index < size else {
            return false
        }
        data[index] = element
        return true
    }
```

然后是检索：

```swift
    func contains(_ element: T) -> Bool {
        for currentIndex in 0..<size where data[currentIndex] == element {
            return true
        }
        return false
    }

    func firstIndex(of element: T) -> Int? {
        for currentIndex in 0..<size where data[currentIndex] == element {
            return currentIndex
        }
        return nil
    }
```

接下来是插入：

```swift
    @discardableResult
    func insert(_ element: T, at destIndex: Int) -> Bool {
        // 参数校验
        guard destIndex >= 0, destIndex <= size else {
            return false
        }
        // 容量校验，如果容量不足，触发扩容操作
        if size >= capacity {
            resize(to: capacity * resizeFactor)
        }
        for currentIndex in (destIndex..<size).reversed() {
            data[currentIndex + 1] = data[currentIndex]
        }
        data[destIndex] = element
        size += 1
        return true
    }

    @discardableResult
    func addFirst(_ element: T) -> Bool {
        return insert(element, at: size)
    }

    @discardableResult
    func addLast(_ element: T) -> Bool {
        return insert(element, at: 0)
    }
```

这里要特别注意的是，在插入一个元素之前，如果当前 ArrayList 的 size 已经和底层数组的 capacity 相同时，需要触发扩容操作。实现也很简单，直接将 capacity 扩容到 resizeFactor 倍（如 Java 中的扩容系数为 1.5）：
`resize(to: capacity * resizeFactor)`，resize 函数的实现稍后再看。

最后实现删除：

```swift
    @discardableResult
    func remove(at index: Int) -> T? {
        // 参数校验
        guard index >= 0, index < size else {
            return nil
        }
        let elementToRemove = data[index]
        for currentIndex in index..<size-1 {
            data[currentIndex] = data[currentIndex + 1]
        }
        data[size-1] = nil
        size -= 1
        // 动态缩容，并防止复杂度震荡
        if size == capacity / resizeFactor / resizeFactor && capacity / resizeFactor != 0 {
            resize(to: capacity / resizeFactor)
        }
        return elementToRemove
    }

    @discardableResult
    func removeFirst() -> T? {
        return remove(at: 0)
    }

    @discardableResult
    func removeLast() -> T? {
        remove(at: size - 1)
    }
```

在删除元素触发缩容时，并没有采用 resizeFactor 作为系数，而是在容量变为之前的 (1 / resizeFactor ^ 2) 时，进行缩容，理由是为了防止连续的添加、删除操作造成的频繁容量变更，造成复杂度震荡。

#### 1.2 链表（LinkedList）

相比数组，链表是一种稍微复杂一点的数据结构。数组需要一块连续的内存空间来存储，对内存的要求比较高。而链表恰恰相反，它并不需要一块连续的内存空间，它通过“指针”将一组**零散的内存块**串联起来使用。

我们把内存块称为链表的“结点”。为了将所有的结点串起来，每个链表的结点除了存储数据之外，还需要记录链上的下一个结点的地址。

结点的定义如下：

```swift
public class Node<T> {

    public var val: T?
    public var next: Node?

    public init(_ val: T? = nil, next: Node? = nil) {
        self.val = val
        self.next = next
    }
}
```

利用结点的定义，继而可以将 LinkedList 定义为：

```swift
public class LinkedList<T> {

    private(set) var size: Int
    private var dummyHead: Node<T>?

    init() {
        self.size = 0
        self.dummyHead = Node()
    }

    var isEmpty: Bool {
        return size == 0
    }
}
```

首先还是实现链表的访问和检索：

```swift
    func getElement(at index: Int) -> T? {
        guard index >= 0, index < size else { return nil }
        // 从第一个节点开始遍历
        var currentNode = dummyHead?.next
        for _ in 0..<index {
            currentNode = currentNode?.next
        }
        return currentNode?.val
    }

    func getFirst() -> T? {
        return getElement(at: 0)
    }

    func getLast() -> T? {
        return getElement(at: size - 1)
    }

    @discardableResult
    func setElement(_ element: T, at index: Int) -> Bool {
        guard index >= 0, index < size else { return false }
        var currentNode = dummyHead?.next
        for _ in 0..<index {
            currentNode = currentNode?.next
        }
        currentNode?.val = element
        return true
    }

    func contains(_ element: T) -> Bool {
        var currentNode = dummyHead?.next
        while currentNode != nil {
            if currentNode?.val == element {
                return true
            }
            currentNode = currentNode?.next
        }
        return false
    }
```

链表的添加：

```swift
    @discardableResult
    func insert(_ element: T, at index: Int) -> Bool {
        guard index >= 0, index <= size else { return false }
        var prevNode = dummyHead
        for _ in 0..<index {
            prevNode = prevNode?.next
        }
        prevNode?.next = Node(element, next: prevNode?.next)
        size += 1
        return true
    }

    func addFirst(_ element: T) {
        insert(element, at: 0)
    }

    func addLast(_ element: T) {
        insert(element, at: size)
    }
```

链表的删除：

```swift
    @discardableResult
    func removeElement(at index: Int) -> T? {
        guard index >= 0, index < size else { return nil }
        var prevNode = dummyHead
        for _ in 0..<index {
            prevNode = prevNode?.next
        }
        let deleteNode = prevNode?.next
        prevNode?.next = deleteNode?.next
        deleteNode?.next = nil
        size -= 1
        return deleteNode?.val
    }

    @discardableResult
    func removeFirst() -> T? {
        return removeElement(at: 0)
    }

    @discardableResult
    func removeLast() -> T? {
        return removeElement(at: size - 1)
    }
```

从实现中可见，由于链表结构使用了不连续的存储空间，天然具有动态容量。在实现插入和删除操作时，并不需要考虑扩容/缩容问题，实现起来较为简单。

其次，在本链表的实现中，使用到了 dummyHead 来降低实现的复杂度。屏蔽了空链表操作和有数据的链表操作的差异，实现起来更为简单。

#### 1.3 列表总结

ArrayList 总结：

- 优点：可随机访问
- 缺点：增加、删除复杂度较高，不适合需要对列表频繁改动的场合

LinkedList 总结：

- 优点：真正的动态，不需要处理固定容量的问题
- 缺点：丧失了随机访问的能力

复杂度分析：

| Time Complexity |   Access   |   Search   |  Insertion  |  Deletion  |
|:----------------|:----------:|:----------:|:-----------:|:----------:|
| ArrayList       | O(1)       | O(N)       | O(N)        | O(N)       |
| LinkedList      | O(N)       | O(N)       | O(1)        | O(1)       |

### 2. 栈（Stack）

#### 2.1 栈的定义

#### 2.2 使用 ArrayList 实现栈

#### 2.3 使用 LinkedList 实现栈

| Time Complexity |   Access   |   Search   |  Insertion  |  Deletion  |
|:----------------|:----------:|:----------:|:-----------:|:----------:|
| ArrayStack      | O(N)       | O(N)       | O(1)        | O(1)       |
| LinkedStack     | O(1)       | O(N)       | O(1)        | O(1)       |

### 3. 队列（Queue）

#### 3.0 队列的定义

#### 3.1 使用 ArrayList 实现队列

#### 3.2 克服 ArrayQueue 的弊端

#### 3.3 使用 LinkedList 实现队列

#### 3.4 克服 LinkedQueue 的弊端

| Time Complexity |   Access   |   Search   |  Insertion  |  Deletion  |
|:----------------|:----------:|:----------:|:-----------:|:----------:|
| ArrayQueue      | O(1)       | O(N)       | O(N)        | O(N)       |
| CircularQueue   | O(N)       | O(N)       | O(1)        | O(1)       |
| LinkedQueue     | O(N)       | O(N)       | O(1)        | O(1)       |
| DualLinkedQueue | O(N)       | O(N)       | O(1)        | O(1)       |

### 4. 双端队列（Deque）


```swift

```