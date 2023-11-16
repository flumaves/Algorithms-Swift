//
//  PriorityQueue.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/17.
//

import Foundation

// MARK: 优先队列
// 很多程序需要处理有序的元素，但不一定要求全部有序，或是一次性将它们排序
// 很多情况下，我们会收集一些元素，处理其中最大的元素，再收集一些元素，处理最大的元素。
// 这种情况下，一个合适的数据结构应该支持两种操作：删除最大元素和插入元素。这种数据结构就叫做优先队列

// 优先队列是一种抽象数据类型，下面先定义一些 API 来提供规范
// 1. delMax()  删除最大元素（如果允许重复元素，最大元素表示其中一个）
// 2. insert()  插入元素
// 4. isEmpty() 优先队列是否为空
// 5. size()    优先队列中元素的个数

// 初级实现
// 当队列比较小时，可以使用 有序/无序 的 数组/链表
// 使用 无序序列 解决是 惰性方法，只有在必要的时候才采取行动（只有 delMax 操作时才遍历一次找出最大的元素）
// 使用 有序序列 解决是 积极方法，因为会在插入时就保持列表有序，让后面的操作尽可能高效
// 对于 栈/队列，我们能够在常数级别的时间内完成所有操作，但是对于优先队列，在初级实现中，插入元素和删除元素这两个操作之一，最坏的情况需要线性时间来完成。
// 而基于数据结构 堆 的实现能保证这两个操作都能快速完成。

// 数据结构 ｜ 插入元素 ｜ 删除最大元素
// 有序数组 ｜   N    ｜     1
// 无序数组 ｜   1    ｜     N
// 堆      ｜  lgN   ｜    lgN
// 理想情况 ｜   1    ｜     1

class PriorityQueue<Item: Comparable> {
    private var pq = [Item?]() // 基于堆的完全二叉树
    private var N  = 0         // 使用 pq[1...N]，pq[0] 不使用

    
    /// 插入单个元素
    func insert(_ item: Item) {
        if N == 0 { pq.append(nil) } // 为 pq[0] 设置一个值
        pq.append(item)
        N += 1
        swim(N)
    }
    
    /// 批量插入元素
    func insert(_ items: [Item]) {
        for item in items {
            insert(item)
        }
    }
    
    /// 删除最大的元素
    func delMax() -> Item? {
        if N == 0 { return nil }
        let result = pq.remove(at: 1)
        N -= 1
        if let lastItem = pq.popLast() {
            pq.insert(lastItem, at: 1)
            sink(1)
        }
        return result
    }
    
    /// 返回优先队列中是否为空
    func isEmpty() -> Bool {
        return N == 0
    }
    
    /// 返回优先队列的大小
    func size() -> Int {
        return N
    }
}
// 对于一个含有 N 个元素的基于堆的优先队列，它的插入元素的操作最多需要 lgN+1 次比较，删除最大元素的操作需要 2lgN 次比较

// 辅助方法
extension PriorityQueue {
    private func less(_ v: Int, than w: Int) -> Bool {
        return pq[v]! < pq[w]!
    }
    
    private func exch(v: Int, w: Int) {
        let temp = pq[v]
        pq[v] = pq[w]
        pq[w] = temp
    }
    
    /// 上浮操作
    private func swim(_ k: Int) {
        var k = k
        while k > 1 && less(k/2, than: k) {
            exch(v: k, w: k/2)
            k = k/2
       }
    }
    
    /// 下沉操作
    private func sink(_ k: Int) {
        var k = k
        while 2 * k < N {
            var j = 2 * k
            if j < N && less(j, than: j+1) { j += 1 }
            if !less(k, than: j) { break }
            exch(v: k, w: j)
            k = j
        }
    }
}



/// 最小优先队列
class MinPQ<Item: Comparable> {
    private var pq = [Item?]()   // 基于堆的完全二叉树
    private var N = 0           // 使用 pq[1...N]，pq[0] 不使用
    
    /// 插入新的元素
    func insert(_ item: Item) {
        if N == 0 { pq.append(nil) }
        pq.append(item)
        N += 1
        swin(N)
    }
    
    /// 插入一组新元素
    func insert(_ items: [Item]) {
        for item in items { insert(item) }
    }
    
    /// 删除最小的元素
    func delMin() -> Item? {
        if N == 0 { return nil }
        let result = pq.remove(at: 1)
        N -= 1
        if let lastItem = pq.popLast() {
            pq.insert(lastItem, at: 1)
            sink(1)
        }
        return result
    }
    
    /// 返回优先队列中是否为空
    func isEmpty() -> Bool { return N == 0 }
    
    /// 返回优先队列的大小
    func size() -> Int { return N }
}

extension MinPQ {
    /// 对第 index 个元素执行上浮操作
    private func swin(_ index: Int) {
        var index = index
        while index > 1 && pq[index]! < pq[index/2]! {
            exchElement(in: index, and: index/2)
            index = index / 2
        }
    }
    
    /// 下沉第 index 个元素
    private func sink(_ index: Int) {
        var index = index
        while 2 * index < N {
            var anotherIndex = 2 * index
            if anotherIndex < N && pq[index+1]! < pq[index]! { anotherIndex += 1 }  // 让更小的元素上浮
            if pq[anotherIndex]! > pq[index]! { break }
            exchElement(in: index, and: anotherIndex)
            index = anotherIndex
        }
    }
    
    /// 交换两个 index 中对应的元素
    private func exchElement(in index: Int, and anotherIndex: Int) {
        let temp = pq[index]
        pq[index] = pq[anotherIndex]
        pq[anotherIndex] = temp
    }
}
