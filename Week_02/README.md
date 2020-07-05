# WEEK 2-1: 散列表、映射和集合

## 1. 散列表

### 1.1 散列表的定义

**散列表**用的是数组支持按照下标随机访问数据的特性，所以散列表其实就是数组的一种扩展，由数组演化而来。可以说，如果没有数组，就没有散列表。

### 1.2 散列函数

**散列函数**，顾名思义，它是一个函数。我们可以把它定义成 hash(key)，其中 key 表示元素的键值，hash(key) 的值表示经过散列函数计算得到的散列值。

散列函数设计的三点基本要求：
1. 散列函数计算得到的散列值是一个非负整数；
2. 如果 key1 = key2，那 hash(key1) == hash(key2)；
3. 如果 key1 ≠ key2，那 hash(key1) ≠ hash(key2)。

### 1.3 散列冲突
再好的散列函数也无法避免散列冲突。我们常用的散列冲突解决方法有两类，**开放寻址法**（open addressing）和**链表法**（chaining）。

#### 1. 开放寻址法

开放寻址法的核心思想是，如果出现了散列冲突，我们就重新探测一个空闲位置，将其插入。

##### 线性探测（Linear Probing）
当我们往散列表中插入数据时，如果某个数据经过散列函数散列之后，存储位置已经被占用了，我们就从当前位置开始，依次往后查找，看是否有空闲位置，直到找到为止。对于使用线性探测法解决冲突的散列表，删除操作稍微有些特别。我们不能单纯地把要删除的元素设置为空。

##### 二次探测（Quadratic probing）
所谓二次探测，跟线性探测很像，线性探测每次探测的步长是 1，那它探测的下标序列就是 hash(key)+0，hash(key)+1，hash(key)+2……而二次探测探测的步长就变成了原来的“二次方”，也就是说，它探测的下标序列就是 hash(key)+0，hash(key)+12，hash(key)+22……

##### 双重散列（Double hashing）
所谓双重散列，意思就是不仅要使用一个散列函数。我们使用一组散列函数 hash1(key)，hash2(key)，hash3(key)……我们先用第一个散列函数，如果计算得到的存储位置已经被占用，再用第二个散列函数，依次类推，直到找到空闲的存储位置。

#### 2. 链表法
链表法是一种更加常用的散列冲突解决办法，相比开放寻址法，它要简单很多。

在散列表中，每个“桶（bucket）”或者“槽（slot）”会对应一条链表，所有散列值相同的元素我们都放到相同槽位对应的链表中。

当插入的时候，我们只需要通过散列函数计算出对应的散列槽位，将其插入到对应链表中即可，所以插入的时间复杂度是 O(1)。当查找、删除一个元素时，我们同样通过散列函数计算出对应的槽，然后遍历链表查找或者删除。

![](/resources/15939532649039.jpg)


实际上，这两个操作的时间复杂度跟链表的长度 k 成正比，也就是 O(k)。对于散列比较均匀的散列函数来说，理论上讲，k=n/m，其中 n 表示散列中数据的个数，m 表示散列表中“槽”的个数。

##### Java 中散列冲突的处理

- Java 8 之前，每一个位置对应一个链表；
- Java 8 开始，当哈希冲突达到一定程度后，每一个位置从链表转成红黑树。原因是：虽然红黑树的时间复杂度低，但是在数据规模很小的时候，使用链表却更快——旋转操作可能比顺序查找更耗费时间。

### 1.4 散列表总结

散列表来源于数组，它借助散列函数对数组这种数据结构进行扩展，利用的是数组支持按照下标随机访问元素的特性。散列表两个核心问题是散列函数设计和散列冲突解决。散列冲突有两种常用的解决方法，开放寻址法和链表法。散列函数设计的好坏决定了散列冲突的概率，也就决定散列表的性能。

## 2. 映射



## 3. 集合




# WEEK 2-2: 二叉树、树和图

## 1. 树的定义

树（tree）是一种抽象数据类型（ADT），用来模拟具有树状结构性质的数据集合。它是由n（n>0）个有限节点通过连接它们的边组成一个具有层次关系的集合。把它叫做“树”是因为它看起来像一棵倒挂的树，也就是说它是根朝上，而叶朝下的。

### 1.1 高度、深度、层

关于“树”，还有三个比较相似的概念：高度（Height）、深度（Depth）、层（Level）。

![](/resources/15939632440679.jpg)


### 1.2 二叉树、满二叉树、完全二叉树

**二叉树**：二叉树（Binary Tree）是包含个节点的有限集合，该集合或者为空集（此时，二叉树称为空树），或者由一个根节点和两棵互不相交的、分别称为根节点的左子树和右子树的二叉树组成。

**满二叉树**：对于一棵二叉树，如果每一个非叶子节点都存在左右子树，并且二叉树中所有的叶子节点都在同一层中，这样的二叉树称为满二叉树。

**完全二叉树**：对于一棵具有个节点的二叉树按照层次编号，同时，左右子树按照先左后右编号，如果编号为的节点与同样深度的满二叉树中编号为的节点在二叉树中的位置完全相同，则这棵二叉树称为完全二叉树。

### 1.3 二叉树的存储方法

想要存储一棵二叉树，我们有两种方法，一种是基于指针或者引用的二叉链式存储法，一种是基于数组的顺序存储法。

1. **链式存储法**：每个节点有三个字段，其中一个存储数据，另外两个是指向左右子节点的指针。我们只要拎住根节点，就可以通过左右子节点的指针，把整棵树都串起来。这种存储方式我们比较常用。大部分二叉树代码都是通过这种结构来实现的。
2. **顺序存储法**：把根节点存储在下标 i = 1 的位置，那左子节点存储在下标 2 * i = 2 的位置，右子节点存储在 2 * i + 1 = 3 的位置。以此类推，B 节点的左子节点存储在 2 * i = 2 * 2 = 4 的位置，右子节点存储在 2 * i + 1 = 2 * 2 + 1 = 5 的位置。（如果某棵二叉树是一棵完全二叉树，那用数组存储无疑是最节省内存的一种方式）

![](/resources/15939633211034.jpg)
![](/resources/15939633737435.jpg)

## 2. 二叉树的遍历

### 2.1 深度优先遍历（前、中、后序）

#### 递归写法

```python
# 前序优先遍历
def pre_order(node, result):
    if node:
        result.append(node.key)
        pre_order(node.left, result)
        pre_order(node.right, result)
    return result

# 中序优先遍历
def in_order(node, result):
    if node:
        in_order(node.left, result)
        result.append(node.key)
        in_order(node.right, result)
    return result

# 后序优先遍历
def post_order(node, result):
    if node:
        post_order(node.left, result)
        post_order(node.right, result)
        result.append(node.key)
    return result
```

#### 非递归写法

```python

```

### 2.2 广度优先遍历（层序）

#### 层序遍历连续输出
```python
# 层序遍历
def level_order(root):
    if not root:
        return []
    result, queue = [], []
    queue.append(root)
    while queue:
        node = queue.pop(0)
        result.append(node.key)
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)
    return result
```

#### 层序遍历分层输出
```python
def level_order_hierarchical(root):
    if not root:
        return []
    result, queue = [], []
    queue.append((root, 0))
    while queue:
        node, level = queue.pop(0)
        if level == len(result):
            result.append([])
        result[level].append(node.val)
        if node.left:
            queue.append((node.left, level+1))
        if node.right:
            queue.append((node.right, level+1))
    return result
```


## 3. 二分搜索树

二叉搜索树，也称二叉搜索树、有序二叉树（Ordered Binary Tree）、 排序二叉树（Sorted Binary Tree），是指一棵空树或者具有下列性质的 二叉树：
1. 左子树上所有结点的值均小于它的根结点的值；
2. 右子树上所有结点的值均大于它的根结点的值；
3. 以此类推：左、右子树也分别为二叉查找树。

### 3.1 二分搜索树的数据结构

```python
# 二分搜索树的节点
class TreeNode:
    def __init__(self, k, v):
        self.key = k
        self.value = v
        self.left = None
        self.right = None
```

### 3.2 插入节点

```python
# 向二分搜索树中插入节点
def insert(node, key, value):
    if node is None:
        return TreeNode(key, value)
    if key == node.key:
        node.value = value
    elif key < node.key:
        node.left = insert(node.left, key, value)
    else:
        node.right = insert(node.right, key, value)
    return node
```

### 3.3 查找 key 对应的 value

```python
# 在二分搜索树中查找key对应的value
def search(node, key):
    if node is None:
        return None
    if key == node.key:
        return node.value
    elif key < node.key:
        return search(node.left, key)
    else:
        return search(node.right, key)
```

### 3.4 查找最大、最小节点

```python
def find_minimum(node):
    if node.left is None:
        return node
    return find_minimum(node.left)

def find_maximum(node):
    if node.right is None:
        return node
    return find_maximum(node.right)
```

### 3.5 删除最大、最小节点
 
最大的节点总在最右侧，最小的节点总在最左侧

```python
def remove_minimum(node):
    if node is None:
        raise Exception('This is an empty tree')
    if node.left is None:
        right_node = node.right
        del node
        return right_node
    node.left = remove_minimum(node.left)
    return node

def remove_maximum(node):
    if node is None:
        raise Exception('This is an empty tree')
    if node.right is None:
        left_node = node.left
        del node
        return left_node
    node.right = remove_maximum(node.right)
    return node
```

 
### 3.6 删除任意节点

Hubbard Deletion

- 用右子树中最小节点替代删除节点，或
- 用左子树中最大节点替代删除节点。

```python
# Hubbard Deletion, 返回最新的node节点
def remove(node, key):
    if node is None:
        return None
    # 递归在左子树删除
    if key < node.key:
        node.left = remove(node.left, key)
        return node
    # 递归在右子树删除
    elif key > node.key:
        node.right = remove(node.right, key)
        return node
    # 删除当前结点
    else:  # key == node.key
        # 情况1: 左侧是空，直接用右子树取代
        if node.left is None:
            right_tree = node.right
            del node
            return right_tree
        # 情况2: 右侧是空，直接用左子树取代
        if node.right is None:
            left_tree = node.left
            del node
            return left_tree
        # 情况3: 左右都不为空，寻找右侧最小的作为继任
        successor = find_minimum(node.right).copy()
        successor.right = remove_minimum(node.right)
        successor.left = node.left
        del node
        return successor
```

## 4. 堆

### 4.1 堆的性质

- 堆中某个结点的值总是不大于其父亲节点的值（**最大堆**）
- 堆总是一棵**完全二叉树**：除了最后一层，其他层节点书必须是最大值，且集中在最左侧
- _并不意味着层数越高数值越大_

### 4.2 堆的存储：使用数组存储二叉堆
1. 如果下标从 0 开始：
	- i的左孩子是 2i+1，右孩子是 2i+2.
	- i的父亲节点是 (i-1)/2.
2. 如果下标从 1 开始：
	- i的左孩子是 2i，右孩子是 2i+1.
	- i的父亲节点是 i/2.

### 4.3 堆排序

#### 使用 ShiftUp / ShiftDown 进行堆排序

向堆中添加元素：Shift Up
1. 添加到堆的末尾
2. 和父节点比较，如果比父节点大，则交换位置
3. 重复第2步直到比父节点小，满足最大堆定义

```python
def shift_up(a, n):
    i = n
    while i > 1:
        p = i / 2
        if a[p] >= a[i]:
            break
        swap(a[p], a[i])
        i = p
```

从堆中取出元素：Shift Down
1. 取出堆顶元素，并把最后一个元素挪到第一个
2. 与左右孩子中最大的节点换位置
3. 重复第2步直到比左右孩子都大或者没有左右孩子

```python
def shift_down(a, n):
    i = 1
    while i*2 <= n:
        c = i*2
        if c+1 <= n and a[c+1] > a[c]:
            c += 1
        if a[c] <= a[i]:
            break
        swap(a[c], a[i])
        i = c
```

进行堆排序

```python
def heap_sort(a, n):
    for i in range(2, n+1):
        shift_up(a, i)
    for i in range(n, 1, -1):
        swap(a[1], a[i])
        shift_down(a, i-1)
```

#### 使用 Heapify 进行堆排序

将普通列表转换成堆：Heapify
1. 从第一个非叶子节点(count/2)开始，与左右孩子进行比较
2. 对每个非叶子节点，进行Shift Down操作，一定要Shift Down到底
3. 直到执行到根节点，Heapify结束

```python
# 用arr中[1,n]的元素构建一个堆
def heap_bottom_up(arr, n):
    # 遍历所有的非叶子节点
    for i in range(n / 2, 0, -1):
        parent = arr[i]
        heap = False
        while not heap and 2 * i <= n:
            j = 2 * i
            if j < n and arr[j] < arr[j + 1]:
                j += 1
            if parent >= arr[j]:
                heap = True
            else:
                arr[i] = arr[j]
                i = j
        arr[i] = parent
    return arr
```

进行堆排序

```python
def heap_sort(arr, n):
    n = len(arr)
    arr = [-1] + arr
    while n >= 1:
        heap_bottom_up(arr, n)
        arr[1], arr[n] = arr[n], arr[1]
        n -= 1
    return arr[1:]
```

## 5. 图

### 5.1 图的存储

#### 邻接矩阵

#### 邻接表

### 5.2 图的遍历

图的遍历（Graph Transversal）类似于树的遍历（事实上，树可以看成是图的一个特例），也分为深度优先和广度优先。

#### 深度优先遍历

深度优先算法尽可能“深”地搜索一个图。对于某个节点 v，如果它有未搜索的边，则沿着这条边继续搜索下去，直到该路径无法发现新的节点，回溯回节点 v，继续搜索它的下一条边。深度优先算法也通过着色标记节点，白色表示未被发现，灰色表示被发现，黑色表示已访问。算法通过递归实现先进后出。一句话总结，深度优先算法一旦发现没被访问过的邻近节点，则立刻递归访问它，直到所有邻近节点都被访问过了，最后访问自己。

《算法导论》第 22 章关于图的基本算法部分给出了深度优先的伪代码实现， 引用如下：

```shell
DFS(G)
for each vertex v in G
    do Color[v] = WHITE
    Parent[v] = NIL
for each vertex v in G
    DFS_Visit(v)

DFS_Visit(u)
Color[u] = GRAY
for each neighbor v of u
    if Color[v] == WHITE
        Parent[v] = u
        DFS_Visit(v)
Color[u] = BLACK
```

_深度优先遍历的一个用途就是计算连通分量。_

#### 广度优先遍历

对于某个节点，广度优先会先访问其所有邻近节点，再访问其他节点。即，对于任意节点，算法首先发现距离为 d 的节点，当所有距离为 d 的节点都被访问后，算法才会访问距离为 d+1 的节点。广度优先算法将每个节点着色为白、灰或黑，白色表示未被发现，灰色表示被发现，黑色表示已访问。算法利用先进先出队列来管理所有灰色节点。一句话总结，广度优先算法先访问当前节点，一旦发现未被访问的邻近节点，推入队列，以待访问。

《算法导论》第 22 章关于图的基本算法部分给出了广度优先的伪代码实现， 引用如下：

```shell
BFS(G, s)
for each vertex u except s
    do Color[u] = WHITE
        Distance[u] = MAX
        Parent[u] = NIL
Color[s] = GRAY
Distance[s] = 0
Parent[s] = NIL
Enqueue(Q, s)

While Q not empty
    Do u = Dequeue(Q)
        For each v is the neighbor of u
            do if Color[v] == WHITE
                Color[v] = GRAY
                Distance[v] = Distance[u] + 1
                Parent[v] = u
                Enqueue(Q, v)
            Color[u] = BLACK
```

### 5.3 最小生成树

前提：带权无向图

这里讨论的两种最小生成树算法 Prim 算法和 Kruskal 算法都是贪心算法。

贪心算法的每一步必须在多个可能的选择中选择一种，贪心算法推荐选择在当前看来最好的选择。这种策略一般并不能保证找到一个全局最优的解决方案。但是对于最小生成树问题来说，可以证明确实能找到权重最小的生成树。

#### 贪心算法的思路

**切分**：把图中的结点分为两部分，成为一个切分(Cut)。
**横切边**：如果一个边的两个端点，属于切分不同的两边，这个边称为横切边(Corssing Edge)。

**切分定理**：给定__任意__切分，横切边中最小的边必然属于最小生成树。


```shell
GENERIC-MST(G, w)
    A = nil
    while A does not form a spanning tree
        find an edge (u,v) that is safe for A
        add (u,v) to A
    return A
```

#### Kruskal's Algorithm

使用数据结构：并查集

```shell
MST-KRUSKAL(G, w)
    A = []
    UNION-FIND(G.V)
    sort the edges of G.E into nondecreasing order by weight w
    for each edge (u,v) from G.E
        if UNION-FIND.find(u) != UNIONFIND.find(v)
            add (u,v) to A
            UNION-FIND.union(u,v)
    return A
```

#### Prim's Algorithm

使用数据结构：最小优先队列

```shell
Input: G-Graph, w-weight, r-root
```


### 5.4 单源最短路径

> 对于每条边都有一个权值的图来说，单源最短路径问题是指从某个节点出 发，到其他节点的最短距离。该问题的常见算法 Bellman-Ford 和 Dijkstra 算法。前者适用于一般情况(包括存在负权值的情况，但不存在从源点可达的负权值回路)，后者仅适用于均为非负权值边的情况。Dijkstra 的运行时间可以小于 Bellman-Ford。

特别地，如果每条边权值相同(无权图)，由于从源开始访问图遇到节点的 最小深度就等于到该节点的最短路径，因此 Priority Queu 就退化成 Queue，Dijkstra 算法就退化成 BFS。

#### Dijkstra's Algorithm

Dijkstra 的核心在于，构造一个节点集合 S，对于 S 中的每一个节点，源点到该节点的最短距离已经确定。进一步地，对于不在 S 中的节点，我们总是选择其中到源点最近的节点，将它加入 S，并且更新其邻近节点到源点的距离。算法实现时需要依赖优先队列。

一句话总结，Dijkstra 算法利用贪心的思想，在剩下的节点中选取离源点最近的那个加入集合，并且更新其邻近节点到源点的距离，直至所有节点都被加入集合。关于 Dijkstra 算法的正确性分析，可以使用数学归纳法证明，详见《算法导论》第 24 章单源最短路径。这里给出伪代码如下:

前提：
- 没有负权边

```
DIJKSTRA(G, s)
S = EMPTY
Insert all vertexes into Q 
While Q is not empty
    u = Q.top
    S.insert(u)
    For each v is the neighbor of u
        If d[v] > d[u] + weight(u, v) 
            d[v] = d[u] + weight(u, v) 
            parent[v] = u
```

复杂度 $O(E \log V)$

#### Bellman-Ford Algorighm

前提：
- 可以有负权边，不能有负权环

复杂度 $O(EV)$


### 5.5 多源最短路径

> 另一个关于图常见的算法是，如何获得任意两点之间的最短距离(All-pairs shortest paths)。直观的想法是，可以对于每个节点运行 Dijkstra 算法，该方法可行，但更适合的算法是 Floyd-Warshall 算法。

#### Floyd's Algorithm

Floyd 算法的核心是动态规划，利用二维矩阵存储 i，j 之间的最短距离，矩阵的初始值为 i，j 之间的权值，如果 i，j 不直接相连，则值为正无穷。动态规划的递归式为:
$$ d_{ij}^{(k)}=min(d_{ij}^{(k-1)},d_{ik}^{(k-1)}+d_{kj}^{(k-1)}) $$

直观上理解，对于第 k 次更新，我们比较从 i 到 j 只经过节点编号小于 k 的中间节点 $d_{ij}^{(k-1)}$，和从 i 到 k，从 k 到 j 的距离之和 $d_{ik}^{(k-1)}+d_{kj}^{(k-1)}$。

Floyd算法的复杂度是 $O(n^3)$。关于Floyd 算法的理论分析，请见《算法导论》第 25 章所有结点对的最短路径问题。这里 给出伪代码如下:

```
FLOYD(G)
Distance(0) = Weight(G) 
For k = 1 to n
    For i = 1 to n 
        For j = 1 to n
            Distance(k)_ij = min(Distance(k-1)_ij, Distance(k-1)_ik+ Distance(k-1)_kj) 
Return Distance(n)
```


### 5.6 最长路径问题

- 最长路径不能有正权环
- 无权图的最长路径问题是指数级难度的
- 对于有权图，不能使用 Dijkstra 算法
- 可以使用 Bellman-Ford 算法

