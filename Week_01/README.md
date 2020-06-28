# WEEK 1: 列表、栈和队列

- [WEEK 1: 列表、栈和队列](#week-1---------)
  * [1. 列表（List）](#1----list-)
    + [1.1 数组（ArrayList）](#11----arraylist-)
    + [1.2 链表（LinkedList）](#12----linkedlist-)
    + [1.3 列表总结](#13-----)
  * [2. 栈（Stack）](#2---stack-)
    + [2.1 栈的定义](#21-----)
    + [2.2 使用 ArrayList 实现栈](#22----arraylist----)
    + [2.3 使用 LinkedList 实现栈](#23----linkedlist----)
    + [2.4 栈的总结](#24-----)
  * [3. 队列（Queue）](#3----queue-)
    + [3.0 队列的定义](#30------)
    + [3.1 使用 ArrayList 实现队列](#31----arraylist-----)
    + [3.2 克服 ArrayQueue 的弊端](#32----arrayqueue----)
    + [3.3 使用 LinkedList 实现队列](#33----linkedlist-----)
    + [3.4 克服 LinkedQueue 的弊端](#34----linkedqueue----)
    + [3.5 队列总结](#35-----)

## 1. 列表（List）

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

### 1.1 数组（ArrayList）

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

### 1.2 链表（LinkedList）

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

### 1.3 列表总结

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

## 2. 栈（Stack）

### 2.1 栈的定义

> 堆栈（Stack）又称为栈或堆叠，是计算机科学中的一种抽象数据类型，只允许在有序的线性数据集合的一端（堆栈顶端）进行加入数据（push）和移除数据（pop）的运算。因而按照后进先出（LIFO, Last In First Out）的原理运作。

从栈的操作特性上来看，**栈是一种“操作受限”的线性表**，只允许在一端插入和删除数据。为什么要对线性表操作进行限制呢？线性表完全可以代替栈，但是因为暴露了太多的操作接口，操作上的确灵活自由造成使用时就比较不可控，也就更容易出错。

当某个数据集合只涉及在一端插入和删除数据，并且满足后进先出、先进后出的特性，我们就应该首选“栈”这种数据结构。

栈限定了列表一端的操作：

```swift
public protocol Stack {

    associatedtype T: Equatable

    var isEmpty: Bool { get }

    func push(_ element: T)
    func pop() -> T?
    func peek() -> T?
}
```

### 2.2 使用 ArrayList 实现栈

由于 ArrayList 和 LinkedList 都实现了前面定义的 List 的所有操作，所以都能作为基础结构来实现栈。

用 ArrayList 实现栈非常简单：

```swift
public class ArrayStack<T: Equatable>: Stack {

    private var arrayList: ArrayList<T>

    init(initialCapacity: Int = 10) {
        self.arrayList = ArrayList(initialCapacity: initialCapacity)
    }

    private var capacity: Int {
        return arrayList.capacity
    }

    public var size: Int {
        return arrayList.size
    }

    public var isEmpty: Bool {
        return arrayList.isEmpty
    }

    public func push(_ element: T) {
        arrayList.addFirst(element)
    }

    @discardableResult
    public func pop() -> T? {
        arrayList.removeLast()
    }

    public func peek() -> T? {
        return arrayList.getLast()
    }
}
```

只要简单调用 List 的 addLast 和 removeLast 操作，就能实现栈。由于前面实现的 ArrayList 是可以动态扩容的，实现的栈也支持动态扩容。

### 2.3 使用 LinkedList 实现栈

用 LinkedList 实现栈也非常简单：

```swift
public class LinkedStack<T: Equatable>: Stack {

    private var linkedList: LinkedList<T>

    init() {
        self.linkedList = LinkedList<T>()
    }

    public var size: Int {
        return linkedList.size
    }

    public var isEmpty: Bool {
        return linkedList.isEmpty
    }

    public func push(_ element: T) {
        linkedList.addFirst(element)
    }

    @discardableResult
    public func pop() -> T? {
        linkedList.removeFirst()
    }

    public func peek() -> T? {
        return linkedList.getFirst()
    }
}
```

和 ArrayStack 不同的是，这里实现 push 和 pop 操作使用的是 LinkedList 的 addFirst 和 removeFirst 方法。由于底层数据结构特性的不同，ArrayList 操作尾部比较方便，而 LinkedList 操作头部比较方便，所以考虑到性能，两种栈的实现具有不同的出栈、如栈方向。两种实现对于 API 来说是不透明的，使用起来不会有任何区别。

### 2.4 栈的总结

| Time Complexity |   Access   |   Search   |  Insertion  |  Deletion  |
|:----------------|:----------:|:----------:|:-----------:|:----------:|
| ArrayStack      | O(N)       | O(N)       | O(1)        | O(1)       |
| LinkedStack     | O(1)       | O(N)       | O(1)        | O(1)       |

## 3. 队列（Queue）

### 3.0 队列的定义

> 队列（queue），是先进先出（FIFO, First-In-First-Out）的线性表。在具体应用中通常用链表或者数组来实现。队列只允许在后端（称为rear）进行插入操作，在前端（称为front）进行删除操作。

队列跟栈非常相似，支持的操作也很有限，最基本的操作也是两个：入队（enqueue），放一个数据到队列尾部；出队（dequeue），从队列头部取一个元素。不同的是，队列是双向操作的，一边只能添加，另一边只能删除。

定义队列的操作：

```swift
public protocol Queue {

    associatedtype T: Equatable

    var size: Int { get }
    var isEmpty: Bool { get }

    func enqueue(_ element: T)
    func dequeue() -> T?
    func getFront() -> T?
}

```

### 3.1 使用 ArrayList 实现队列

用 ArrayList 实现队列和实现栈相似：

```swift
public class ArrayQueue<T: Equatable>: Queue {

    private var array: ArrayList<T>

    private var capacity: Int {
        return array.capacity
    }

    public var size: Int {
        return array.size
    }

    public var isEmpty: Bool {
        return array.isEmpty
    }

    init(initialCapacity: Int = 10) {
        self.array = ArrayList(initialCapacity: initialCapacity)
    }

    public func enqueue(_ element: T) {
        array.addFirst(element)
    }

    @discardableResult
    public func dequeue() -> T? {
        return array.removeFirst()
    }

    public func getFront() -> T? {
        return array.getFirst()
    }
}
```

当我们使用 ArrayList 实现 Stack 时，可以将 push 和 pop 操作放到数组尾部以达到最好的性能。而 Queue 则必须要在两端操作，性能问题已无法避免。把 enqueue 操作放在数组尾部，复杂度为 O(1)；dequeue 操作放在头部，复杂度为 O(N)。

### 3.2 克服 ArrayQueue 的弊端

当然还是有办法优化的，这就是双端队列。相比于每次出队都要把后面的元素依次向前移位，双端队列使用两个游标来表示队列头和队列尾，入队的时候将队尾游标后移，出队时将队首游标后移即可。经多数次后移之后，队尾游标有可能出现在队首游标前方，整个数组形成一个环状。

下面来实现一个双端队列：

```swift
class CircularQueue<T: Equatable>: Queue {

    private var frontIndex: Int
    private var tailIndex: Int
    private var data: [T?]

    private var isQueueEmpty: Bool {
        return frontIndex == tailIndex
    }

    private var isQueueFull: Bool {
        return frontIndex == (tailIndex + 1) % data.count
    }

    private var capacity: Int {
        return data.count - 1
    }

    var size: Int

    var isEmpty: Bool {
        return isQueueEmpty
    }

    /// 创建一个循环队列
    /// - Parameter initialCapacity: 队列初始容量，默认为 10
    init(initialCapacity: Int = 10) {
        self.size = 0
        self.frontIndex = 0
        self.tailIndex = 0
        self.data = Array(repeating: nil, count: initialCapacity + 1)
    }

    func enqueue(_ element: T) {
        if isQueueFull {
            resize(to: capacity * resizeFactor)
        }
        data[tailIndex] = element
        tailIndex = (tailIndex + 1) % data.count
        size += 1
    }

    @discardableResult
    func dequeue() -> T? {
        if isQueueEmpty {
            return nil
        }
        let result = data[frontIndex]
        data[frontIndex] = nil
        frontIndex = (frontIndex + 1) % data.count
        size -= 1
        if size == capacity / resizeFactor / resizeFactor && capacity / 2 != 0 {
            resize(to: capacity / resizeFactor)
        }
        return result
    }

    func getFront() -> T? {
        if isQueueEmpty {
            return nil
        }
        return data[frontIndex]
    }
}
```

队首游标 `frontIndex` 指向队首第一个元素，队尾游标 `tailIndex` 指向队尾元素的后一个位置。当 `frontIndex` 和 `tailIndex` 重合时，队列为空，当 `frontIndex` 等于 `(tailIndex + 1) % data.count` 时，队列已满。

`resize` 操作也和之前略有不同，要多维护两个游标：

```swift
extension CircularQueue {

    private var resizeFactor: Int {
        return 2
    }

    private func resize(to newCapacity: Int) {
        var newData: [T?] = Array(repeating: nil, count: newCapacity + 1)
        for currentIndex in 0..<size {
            newData[currentIndex] = data[(frontIndex + currentIndex) % data.count]
        }
        data = newData
        frontIndex = 0
        tailIndex = size
    }
}
```

当重新分配空间后，顺便将 `frontIndex` 和 `tailIndex` 设置到起始状态，即 `frontIndex` 在数组最前，`tailIndex` 在后。

这样实现的双端列表，入队和出队的复杂度都是 O(N)。

### 3.3 使用 LinkedList 实现队列

用 LinkedList 来实现队列：

```swift
class LinkedQueue<T: Equatable>: Queue {

    private var linkedList: LinkedList<T>

    init() {
        self.linkedList = LinkedList<T>()
    }

    public var size: Int {
        return linkedList.size
    }

    public var isEmpty: Bool {
        return linkedList.isEmpty
    }

    func enqueue(_ element: T) {
        linkedList.addFirst(element)
    }

    @discardableResult
    func dequeue() -> T? {
        return linkedList.removeLast()
    }

    func getFront() -> T? {
        return linkedList.getFirst()
    }
}
```

操作简单，不再赘述。弊端和 ArrayQueue 相同。

### 3.4 克服 LinkedQueue 的弊端

上面的实现，麻烦在出队时要从链表尾部删除结点，是 O(N) 的操作。要优化也很容易，只要在链表上除 head 之外，再多记录一个 tail 结点，出队时直接从 tail 开始操作就好了。

由于不是链表的标准实现，所以这里重写一些方法：

```swift
class DualLinkedQueue<T: Equatable>: Queue {

    private var head: Node<T>?
    private var tail: Node<T>?
    private(set) var size: Int

    init() {
        self.head = nil
        self.tail = nil
        self.size = 0
    }

    var isEmpty: Bool {
        return size == 0
    }

    func enqueue(_ element: T) {
        if tail == nil {
            tail = Node(element)
            head = tail
        } else {
            tail?.next = Node(element)
            tail = tail?.next
        }
        size += 1
    }

    @discardableResult
    func dequeue() -> T? {
        if isEmpty {
            return nil
        }
        let dequeueNode = head
        head = head?.next
        dequeueNode?.next = nil
        // 只有一个元素的情况，head == tail
        if head == nil {
            tail = nil
        }
        size -= 1
        return dequeueNode?.val
    }

    func getFront() -> T? {
        if isEmpty {
            return nil
        }
        return head?.val
    }
}
```

### 3.5 队列总结

| Time Complexity |   Access   |   Search   |  Insertion  |  Deletion  |
|:----------------|:----------:|:----------:|:-----------:|:----------:|
| ArrayQueue      | O(N)       | O(N)       | O(1)        | O(N)       |
| CircularQueue   | O(N)       | O(N)       | O(1)        | O(1)       |
| LinkedQueue     | O(N)       | O(N)       | O(1)        | O(1)       |
| DualLinkedQueue | O(N)       | O(N)       | O(1)        | O(1)       |
