//
//  SymbolTable.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/18.
//

import Foundation

// MARK: 符号表
// 符号表目的是将一对键和值联系起来，是一种储存键值对的数据结构，支持两种操作：
// 插入(put)：将一组新的键值对存入表中
// 查找(get)：根据给定的键得到相应的值

// 需要提供的 API
// func put(key: KEY, value: VALUE) // 将键值对存入表中，如果 value 为空，删除 key
// func get(key: KEY) -> VALUE?     // 传入 key，返回对应的 value，如果不存在 key，则返回 nil
// func delete(key: KEY) -> VALUE?  // 从表中删除 key 以及对应的值
// func contains(key: KEY) -> Bool  // 判断表中是否含有 key
// func isEmpty() -> Bool           // 判断表是否为空
// func size() -> Int               // 返回表中键值对的个数
// func keys() -> Iterator<Key>     // 返回一个迭代器，可以遍历表中所有的键值对

// 同时符号表中应当遵循如下规则：
// 每个 key 对应一个 value（表中不允许存在重复的 key）
// 当存入的 key 在表中存在时，新的 value 会取代旧的 value
// key 不能为 nil
// value 不能为 nil

//在学习符号表的实现时，我们会统计比较的次数（等价性测试或是键的相互比较）。在内循环不进行比较（极少）的情况下，我们会统计数组的访问次数。

// 无序链表中的顺序查找
// 符号表中的一个简单实现是使用链表，每一个结点储存一对键值对
class SequentialSearchST<Key: Equatable, Value> {
    private var sentinel: Node = Node()
    private var count = 0
    
    private class Node {
        var key: Key?
        var val: Value?     // sentinel's key and value is nil
        var next: Node?
        
        init(key: Key? = nil, val: Value? = nil, next: Node? = nil) {
            self.key = key
            self.val = val
            self.next = next
        }
    }
    
    /// 获取 key 对应的 value
    func get(_ key: Key) -> Value? {
        var first = sentinel.next
        while first != nil {
            if key == first!.key { return first!.val } // 命中
            first = first!.next
        }
        return nil
    }
    
    func put(value: Value, for key: Key) {
        var first = sentinel
        while first.next != nil {
            first = first.next!
            if key == first.key { first.val = value }
        }
        // key 不存在表中
        let newNode = Node(key: key, val: value)
        first.next = newNode
        
        count += 1
    }
    
    func delete(key: Key) -> Value? {
        var point = sentinel
        while let next = point.next {
            if next.key == key { // 命中
                if let jumpNext = next.next { // 判断是否为末尾元素
                    point.next = jumpNext
                } else {
                    point.next = nil
                }
                return next.val
            }
            point = next
        }
        
        count -= 1
        return nil
    }
    
    func contains(key: Key) -> Bool {
        var point = sentinel
        while let next = point.next {
            if next.key == key { return true }
            point = next
        }
        return false
    }
    
    func isEmpty() -> Bool {
        return count == 0
    }
    
    func size() -> Int {
        return count
    }
}
// 在一个无序链表中，插入和查找需要 N 次比较。向一个空表插入 N 个键值对需要 ~N^2/2 次比较（因为元素不能重复，所以每次插入都需要遍历一次）


// 有序数组中的二分查找
// 下面是有序符号表的实现，用的是一对平行的数组，一个存储键，一个存储值
// 先保证数组中的键的有序，然后使用数组的索引来高效地实现 get() 操作
// 实现的核心是 rank() 方法，它能返回表中小于给定键的数量。
// 对于 get() 方法，只要给定的 key 存在于表中就能够精确地告诉我们在哪里能找到它。
// 对于 put() 方法，只要给定的键存在表中， rank() 就能告诉我们去哪里更新它的值，如果不存在表中，则将所有更大的键向后移动一位腾出位置给新的键值对
class BinarySearchST<Key: Comparable, Value> {
    private var keys: [Key] = [Key]()
    private var vals: [Value] = [Value]()
    private var count = 0 // 表中的键值对数量
    
    func size() -> Int { return count }
    
    func isEmpty() -> Bool { return count == 0 }
    
    func getValue(for key: Key) -> Value? {
        if isEmpty() { return nil }
        let index = rank(key, from: 0, to: count - 1)
        if index < count && keys[index] == key {
            return vals[index]
        } else {
            return nil
        }
    }
    
    func put(_ value: Value, for key: Key) {
        let index = rank(key, from: 0, to: count - 1)
        if index < count && keys[index] == key {
            vals[index] = value
            return
        }
        keys.insert(key, at: index)
        vals.insert(value, at: index)
        count += 1
    }
    
    /// 返回 key 在表中的位置
    /// - Returns: 1. 如果表中存在该键，返回该键的位置（表中小于它的键的数量）  2. 如果表中不存在该键，返回表中小于它的键的数量
    func rank(_ key: Key, from low: Int, to high: Int) -> Int {
        if high < low { return low }
        let mid = low + (high - low) / 2
        if key < keys[mid] {
            return rank(key, from: low, to: mid - 1)
        } else if key == keys[mid] {
            return mid
        } else { // key > keys[mid]
            return rank(key, from: mid + 1, to: high)
        }
    }
    
    func delete(_ key: Key) -> Value? {
        return nil
    }
    
    func min() -> Key? {
        if isEmpty() { return nil }
        return keys[0]
    }
    
    func max() -> Key? {
        if isEmpty() { return nil }
        return keys[count - 1]
    }
    
    /// 返回有序表中第 index 个键值对的 key， 从 0 开始
    func select(_ index: Int) -> Key? {
        if count <= index { return nil }
        return keys[index]
    }
    
    /// 大于等于 key 的最小键
    func ceiling(_ key: Key) -> Key? {
        let index = rank(key, from: 0, to: count - 1)
        return keys[index]
    }
    
    /// 小于等于 key 的最大键
//    func floor(_ key: Key) -> Key? {
//
//    }
    
//    func contains(_ key: Key) -> Bool {
//
//    }
}
// 在 N 个键的有序数组中进行二分查找最多需要 (lgN+1) 次比较（无论是否成功）
// 尽管 BinarySearchST 的查找时间是对数级别的，但是 put() 方法依旧太慢了——在键值随机排列的情况下
// 构造一个基于有序数组的符号表的访问数组的次数是 平方级别。


// 一般情况下，二分查找都比顺序查找快得多，它是众多实际应用程序的最佳选择。
// 对一个静态表（不允许插入），在初始化时将值排序是值得的
// 由于插入操作的成本依旧是 N，所以需要一种新的算法和数据结构保证插入和查找都是对数级别。


/**
    对于高效的插入操作，需要一种链式结构。但单链接的链表无法使用二分查找
    因为二分查找的高效来源于能够快速通过索引取得任何子数组的中间元素（而得到一条链表的中间元素的唯一办法是沿链表遍历）
    而能够同时拥有这两者的灵活性的就是 二叉查找树
 */
// MARK: 二叉查找树
// 一颗二叉查找树(BST)是一颗二叉树，每个结点含有一对键值对，每个结点的键都大于左子树中的任意结点的键而小于右子树中的任意结点的键
class BST<Key: Comparable, Value> {
    private var root: Node?
    
    private class Node {
        var val:   Value
        let key:   Key
        var left:  Node?
        var right: Node?
        var N: Int = 0 // 以该结点为根的子树中的结点的个数
        
        init(val: Value, key: Key, left: Node? = nil, right: Node? = nil, N: Int) {
            self.val = val
            self.key = key
        }
    }
}

extension BST {
    /// 返回 BST 中结点的个数
    func size() -> Int {
        return size(root)
    }
    
    /// 返回以某个结点为根结点的树的结点的个数
    private func size(_ node: Node?) -> Int {
        guard let node = node else { return 0 }
        return node.N
    }
}

extension BST {
    /// 在表中查找 key
    func getValueFor(_ key: Key) -> Value? {
        return getValueFor(key, from: root)
    }
    
    /// 从以 node 为根结点的树中查找 key
    private func getValueFor(_ key: Key, from node: Node?) -> Value? {
        guard let node = node else { return nil } // empty node
        if key < node.key {
            return getValueFor(key, from: node.left)
        } else if key == node.key {
            return node.val
        } else {
            return getValueFor(key, from: node.right)
        }
    }
}

extension BST {
    /// 查找 key 并更新值，如果表中不存在则创建一个新的结点
    func put(_ value: Value, for key: Key) {
        root = put(value, for: key, in: root)
    }
    
    /// 在以 node 为根结点的树中查找 key，存在则修改对应的 value，不存在则创建一个新结点插入到该子树中
    private func put(_ value: Value, for key: Key, in node: Node?) -> Node {
        guard let node = node else {
            return Node(val: value, key: key, N: 1)
        }
        if key < node.key {
            node.left = put(value, for: key, in: node.left)
        } else if key == node.key {
            node.val = value
        } else {
            node.right = put(value, for: key, in: node.right)
        }
        node.N = size(node.left) + size(node.right) + 1
        return node
    }
}
// BST 的算法运行时间取决于树的形状，树的形状取决于键的插入的先后顺序。
// 最优的情况下，一颗 BST 是完全平衡的，每条空链接与根结点的距离为 ~lgN。(类似完全二叉树的形状）
// 最坏的情况下，一颗大小为 N 的 BST 的搜索路径上有 N 个结点，形状为一条链表

extension BST {
    /// 返回 BST 中最大的 key
    func max() -> Key? {
        guard let root = root else { return nil }
        return max(root).key
    }
    
    /// 返回以 node 为根结点的树的最大的 key
    private func max(_ node: Node) -> Node {
        if let right = node.right {
            return max(right)
        }
        return node
    }
    
    /// 返回 BST 中最小的 key
    func min() -> Key? {
        guard let root = root else { return nil }
        return min(root).key
    }
    
    /// 返回以 node 为根结点的树的最小的 key
    private func min(_ node: Node) -> Node {
        if let left = node.left {
            return min(left)
        }
        return node
    }
    
    /// 返回小于等于 key 的最大值
    func floor(_ key: Key) -> Key? {
        return floor(key, in: root)
    }
    
    /// 返回以 node 为根结点的树的小于等于 key 的最大值
    private func floor(_ key: Key, in node: Node?) -> Key? {
        guard let node = node else { return nil }
        if key == node.key {
            return key
        } else if key < node.key {
            return floor(key, in: node.left)
        } else {    // 该树已经小于 key，找到其中最大值
            if let floorKey = floor(key, in: node.right) { return floorKey } // 右子树已经为空，所以返回自身
            return node.key
        }
    }
    
    /// 返回大于等于 key 的最小值
    func ceiling(_ key: Key) -> Key? {
        return ceiling(key, in: root)
    }
    
    /// 返回以 node 为根结点的数的大于等于 key 的最小值
    private func ceiling(_ key: Key, in node: Node?) -> Key? {
        guard let node = node else { return nil }
        if key == node.key {
            return key
        } else if key > node.key {
            return ceiling(key, in: node.right)
        } else {
            if let ceilingKey = ceiling(key, in: node.left) { return ceilingKey }
            return node.key
        }
    }
}

extension BST {
    /// 返回 BST 中排名为 k 的 key，从 0 开始
    func select(_ index: Int) -> Key? {
        return select(index, in: root)
    }
    
    /// 返回以 node 为根结点的树中排名为 k 的结点，从 0 开始
    private func select(_ index: Int, in node: Node?) -> Key? {
        guard let node = node else { return nil }
        let curIndex = size(node.left)
        if index < curIndex {
            return select(index, in: node.left)
        } else if index > curIndex {
            return select(index - curIndex - 1, in: node.right)
        } else {
            return node.key
        }
    }
    
    /// 返回 BST 中小于 key 的键的数量
    func rank(_ key: Key) -> Int {
        return rank(key, in: root)
    }
    
    /// 返回以 node 为根结点的树中小于 key 的键的数量
    private func rank(_ key: Key, in node: Node?) -> Int {
        guard let node = node else { return 0 }
        if key < node.key {
            return rank(key, in: node.left)
        } else if key > node.key {
            return 1 + size(node.left) + rank(key, in: node.right)
        } else {
            return size(node.left)
        }
    }
}

// BST中最难实现的就是 delete() 方法，即从表中删除一个键值对
// 让我们先实现 deleteMin() 方法和 deleteMax() 方法
extension BST {
    // 删除 BST 中 key 最小的键值对
    func deleteMin() {
        root = deleteMin(in: root)
    }
    
    /// 删除以 node 为根结点的树中 key 最小的键值对
    private func deleteMin(in node: Node?) -> Node? {
        guard let node = node else { return nil }
        if node.left == nil { return node.right }
        node.left = deleteMin(in: node.left)
        node.N = 1 + size(node.left) + size(node.right)
        return node
    }
    
    /// 删除 BST 中 key 最大的键值对
    func deleteMax() {
        root = deleteMax(in: root)
    }
    
    /// 删除以 node 为根结点的树中 key 最大的键值对
    private func deleteMax(in node: Node?) -> Node? {
        guard let node = node else { return nil }
        if node.right == nil { return node.left }
        node.right = deleteMax(in: node.right)
        node.N = 1 + size(node.left) + size(node.right)
        return node
    }
    
    /// 删除 BST 中对应的键值对
    func delete(_ key: Key) {
        root = delete(key, in: root)
    }
    
    /// 删除以 node 为根结点的树中对应的键值对
    private func delete(_ key: Key, in node: Node?) -> Node? {
        guard let node = node else { return nil }
        if key < node.key {
            node.left = delete(key, in: node.left)
        } else if key > node.key {
            node.right = delete(key, in: node.right)
        }
        // key == node.key，命中结点
        if node.left == nil { return node.right }
        if node.right == nil { return node.left }
        let temp = min(node.right!)
        temp.right = deleteMin(in: node.right)
        temp.left = node.left
        temp.N = size(temp.left) + size(temp.right) + 1
        return temp
    }
}
// 在一棵二叉查找树中，所有操作在最坏的情况下所需的时间和树的高度成正比
// 在随机构造的树中，所有路径的长度都小于 3lgN。
// 如果构造树的键不是随机的怎么办这个问题没有意义，因为还有 平衡二叉查找树，能保证键的无论键的插入顺序如何，树的高度都将是总键数的对数


// MARK: 平衡查找树
// 虽然二叉查找树已经能很好地运用在许多应用程序中，但是在最坏的情况下，性能还是很糟糕
// 而平衡查找树，无论如何构建，运行时间都是对数级别的。

// 2-3 查找树
// 为了查找树的平衡性，因此在这里 允许树中的结点保存多个键。
// 2-结点，含有一个键和两条链接，左链接指向的 2-3 树中的键都小于该结点，右键指向的 2-3 树中的键都大于该结点
// 3-结点，含有两个键和三条链接，左链接指向的 2-3 树中的键都小于该结点，中链接指向的 2-3 树中的键都位于该结点的两个键之间，右链接指向的 2-3 树中的键都大于该结点
// 一棵完美平衡的 2-3 查找树中所有的空链接到根结点的距离应该是相同的。一棵含有 10 亿个结点的 2-3 树的高度仅在 19 到 30 之间，这是相当惊人的。

// 对于查找操作，先将它和根结点中的键比较，如果和任意一个相等则查找命中，否则根据比较的结果继续递归查找。如果最后是个空链接，则未命中。
// 对于插入操作，向 2-结点 插入新键只需要用 3-结点 替换。向 3-结点 插入新键，需要临时将该 3-结点 变成 4-结点，并将中间键向上传递。如果没有父节点，则该 4-结点 变成 3 个 2-结点。
// 如果父节点为 2-结点，则替换成 3-结点，如果是 3-结点，则重复向上传递中间的键。这样每次插入新键只需要重构这条链上的链接而不会涉及树的其他部分。



// MARK: 红黑二叉查找树
// 当然上面都只是抽象的表达，为了实现它，需要一种名为 红黑二叉查找树 的数据结构来表示。

/**
    红黑二叉查找树基本思想是用标准的二叉查找树和一些额外信息来表示 2-3 树。
    我们将树中的链接分为两种类型：红链接 将两个 2- 结点连接起来构成一个 3- 结点。黑链接 则是 2-3 树中的普通链接。
    这种表示法的优点是：无序修改就可以直接使用二叉查找树中的 get() 方法
 */

/**
    红黑树的另一种定义是含有红黑链接并满足下列条件的二叉查找树：
    1. 红链接均为左链接
    2. 没有任何一个结点同时和两条红链接相连
    3. 该树是完美黑色平衡的
 */

// 颜色表示：每个结点拥有一条来自父结点指向自己的链接，我们将链接的颜色包存在 node 的布尔变量 color 中，红色为 true，黑色为 false
// 并用私有方法来测试结点和父结点之间链接的颜色。

// 旋转：在实现的操作中可能会出现红色的右链接或两条连续的红链接，需要进行旋转来修复。
// 旋转操作会改变红链接的指向。假设一条红色的右链接需要转化为左链接，这个操作叫做左旋转
// 就是将两个键中较小的作为根结点变为将较大者作为根结点。
// 实现一个将红色左链接转换为一个红色右链接的右旋转操作代码差不多。
class RedBlackBST<Key: Comparable, Value> {
    private var root: Node?
    
    private class Node {
        var key:   Key
        var val:   Value
        var N:     Int = 0
        var left:  Node?
        var right: Node?
        var color: Bool     // 父结点指向它的链接的颜色, true 为红链接，false 为黑链接
        
        init(key: Key, val: Value, color: Bool) {
            self.key = key
            self.val = val
            self.color = color
        }
        
        /// 改变结点的颜色
        func flipColor() {
            self.color.toggle()
        }
    }
    
    /// 判断某个结点的父结点指向它的链接的颜色
    private func isRed(_ node: Node?) -> Bool {
        guard let node = node else { return false }
        return node.color
    }
    
    private func size(_ node: Node?) -> Int {
        guard let node = node else { return 0 }
        return 1 + size(node.left) + size(node.right)
    }
}

extension RedBlackBST {
    /// 对 node 结点进行左旋转操作
    private func rotateLeft(_ node: Node) -> Node {
        let temp = node.right!
        node.right = temp.left
        temp.left = node
        temp.color = node.color
        node.color = true
        temp.N = node.N
        node.N = size(node)
        return temp
    }
    
    /// 对 node 结点进行右旋转操作
    private func rotateRight(_ node: Node) -> Node {
        let temp = node.left!
        node.left = temp.right
        temp.right = node
        temp.color = node.color
        node.color = true
        temp.N = node.N
        node.N = size(node)
        return temp
    }
}

extension RedBlackBST {
    /// 往 BST 中添加键值对
    func set(_ value: Value, for key: Key) {
        root = set(value, for: key, in: root)
        if root != nil { root!.color = false }
    }
    
    /// 对以 node 为根结点的 BST 中添加键值对
    private func set(_ value: Value, for key: Key, in node: Node?) -> Node {
        guard let node = node else {
            // 已经是空链接，返回新结点
            return Node(key: key, val: value, color: true)
        }
        
        if key < node.key {
            node.left = set(value, for: key, in: node.left)
        } else if key == node.key {
            node.val = value // 命中
        } else { // key < node.key
            node.right = set(value, for: key, in: node.right)
        }
        
        var temp = node
        if isRed(node.right) && !isRed(node.left) { // 一个红色的右链接，需要左旋
            temp = rotateLeft(temp)
        }
        if isRed(node.left) && isRed(node.left?.left) {
            temp = rotateRight(temp)
        }
        if isRed(node.left) && isRed(node.right) {
            temp.flipColor()
        }
        temp.N = 1 + size(temp.left) + size(node.right)
        return temp
    }
}
