//
//  HeapSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/17.
//

import Foundation


// MARK: 堆排序
// 可以将任意优先队列变成一种排序方法，将所有元素插入一个查找最小元素的优先队列，然后再调用删除最小元素的操作将它们按顺序取出
// 使用无序方法实现的优先队列相当于一次选择排序，而使用堆实现的优先队列相当于 堆排序

// 堆排序可以分为两个阶段
// 堆的构造阶段：将原始数组重新组织安排进一个堆中
// 下沉排序阶段：从堆中按递减顺序取出所有元素并得到结果

// 给定 N 个元素构造一个堆，只需要从左向右遍历数组，用 swim() 保证指针左边的所有元素已经是一颗堆有序的完全树
// 还有另一种更高效的方法，从右往左使用 sink() 遍历数组，如果一个结点的两个子结点都已经是堆，那么在这个结点上调用 sink() 可以建立堆的秩序

class Heap<Item: Comparable> {
    func sort(_ array: inout [Item]) {
        array.insert(array[0], at: 0) // 给数组添加一个空的元素作为 array[0]
        let length = array.count - 1
        for i in (1...length/2).reversed() {
            sink(&array, i, length)
            print("N = \(length) | k = \(i) | \(array)")
        }
        var k = length
        while k > 1 {
            exch(&array, v: 1, w: k)
            k -= 1
            sink(&array, 1, k)
        }
        array.removeFirst() // 删除新加的元素
    }
}

extension Heap{
    private func exch(_ array: inout [Item], v: Int, w: Int) {
        let temp = array[v]
        array[v] = array[w]
        array[w] = temp
    }
    
    private func less<Item: Comparable>(_ v: Item, than w: Item) -> Bool {
        return v < w
    }
    
    private func sink(_ array: inout [Item], _ k: Int, _ N: Int) {
        var k = k
        while 2 * k <= N {
            var j = 2 * k
            if j < N && less(array[j], than: array[j+1]) { j += 1 }
            if !less(array[k], than: array[j]) { break }
            exch(&array, v: k, w: j)
            k = j
        }
    }
}
