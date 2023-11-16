//
//  HashTable.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/24.
//

import Foundation

// MARK: 散列表
/// 使用散列表的查找算法分为两步
/// 1. 用散列函数将被查找的键转化为数组的一个索引，理想情况下不同的键都能被转换成不同的索引。
/// 2. 但是会遇到两个或多个键散列到相同的索引的值的情况，第二步就是一个处理碰撞冲突的过程，例如：拉链法和线性探测法


// MARK: 散列函数
/// 通过散列函数的计算，会将键转换为数组的索引。如果有一个能够保存 M 个键值对的数组，就需要一个能将任意键转化为该数组范围内的索引
/// [0, M -1] 范围的整数的散列函数。
/// 散列函数应该易于计算并且能够均匀分布所有的键。

// 如果散列值的计算很耗时，可以将每个键的散列值换存起来。
// 要为一个数据类型实现一个优秀的散列方法需要满足三个条件：
// 1. 一致性——等价的键必然产生等价的散列值
// 2. 高效性——计算简便
// 3. 均匀性——均匀地散列所有的键


// MARK: 基于拉链法的散列表
// 将大小为 M 的数组中每一个元素指向一条链表，链表中的每个结点都存储在链表中。
// 这个方法基本思想是选择足够大的 M，使得所有链表都尽可能短以保证高效的查找。
// 查找分为两步，首先根据散列值找到对应的链表，然后沿着链表顺序查找相应的键。

// 拉链法的一种实现是使用原始的链表数据类型来拓展 SequentialSearchST。
class SeparateChainingHashST<Key: Hashable, Value> {
    private var count: Int = 0  // 键值对的总数
    private var size:  Int      // 散列表的大小
    private var st:    [SequentialSearchST<Key, Value>]
    
    /// 创建 M 条链表的散列表
    init(size: Int) {
        self.size = size
        st = [SequentialSearchST](repeating: SequentialSearchST(), count: size)
    }
    
    private func hash(_ key: Key) -> Int {
        return (key.hashValue & 0x7fffffff) % size
    }
    
    func getValue(for key: Key) -> Value? {
        return st[hash(key)].get(key)
    }
    
    func set(_ value: Value, for key: Key) {
        st[hash(key)].put(value: value, for: key)
        count += 1
    }
    
    func delete(_ key: Key) -> Value? {
        count -= 1
        return  st[hash(key)].delete(key: key)
    }
}
// 一张含有 M 条链表和 N 个键的散列表中，未命中查找和插入操作所需的比较次数为 ~N/M

/**
 散列的最主要目的在于均匀地将键散布开来，在计算散列后键的顺序信息就丢失了。
 如果需要快速找到最大或最小的键，或是查找某个范围的键，或是有关有序的操作，那么散列表不是合适的选择
 */



// MARK: 基于线性探测法的散列表
// 实现散列表的另一种方式是用大小为 M 的数组保存 N 个键值对，其中 M>N。需要依靠数组中的空位解决碰撞冲突。
// 基于这种策略的所有方法被统称为开放地址散列表
// 开放地址散列表中最简单的方法叫做 线性探测法：当碰撞发生时（一个键的散列值已经被另一个不同的键占用），我们直接检查散列表中的下一个位置。
// 使用散列函数找到键在数组中的索引，检查其中的键和被查找的键是否相同
// 如果不同就继续查找（到达数组末尾则返回开头），直到遇到该键或是一个空元素。

class LinearProbingHashST<Key: Hashable, Value> {
    private var N: Int = 0  // 符号表中键值对的总数
    private var M: Int      // 线性探测表的大小
    private var elements: [(key: Key, value: Value)?]
    
    init(M: Int) {
        self.M = M
        self.elements = [(key: Key, value: Value)?](repeating: nil, count: M)
    }
    
    private func hash(_ key: Key) -> Int {
        return (key.hashValue & 0x7fffffff) % M
    }
    
    /// 重新调整数组的大小
    private func resize(to newSize: Int) {
        let temp = LinearProbingHashST(M: newSize)
        for element in elements {
            if let element = element {
                temp.set(element.value, for: element.key)
            }
        }
        self.elements = temp.elements
        self.N = temp.N
        self.M = temp.M
    }
    
    func set(_ value: Value, for key: Key) {
        if N > M/2 { resize(to: 2 * M) }
        
        var i = hash(key)
        while let element = elements[i] {
            if element.key == key {
                elements[i] = (key, value)
                return
            }
            i = (i + 1) % M
        }
        elements[i] = (key, value)
        N += 1
    }
    
    func getValue(for key: Key) -> Value? {
        var i = hash(key)
        while let element = elements[i] {
            if element.key == key { return element.value }
            i = (i + 1) % M
        }
        return nil
    }
    
    func delete(_ key: Key) -> Value? {
        if !contain(key) { return nil }
        var i = hash(key)
        while elements[i]!.key != key { i = (i + 1) % M }
        let result = elements[i]
        elements[i] = nil
        i = (i + 1) % M
        while let element = elements[i] {
            elements[i] = nil
            N -= 1
            set(element.value, for: element.key)
            i = (i + 1) % M
        }
        N -= 1
        if N > 0 && N == M/8 { resize(to: M/2) }
        return result!.value
    }
    
    private func contain(_ key: Key) -> Bool {
        var i = hash(key)
        while let element = elements[i] {
            if element.key == key { return true }
            i = (i + 1) % M
        }
        return false
    }
}
// 和拉链法一样，开放地址类的散列表性能也依赖于 N/M 的比值，称之为散列表的使用率，表示表中已被占用的空间的比例。
// 为保证性能，会动态调整数组的大小来保证使用率在 1/8 到 1/2 之间
