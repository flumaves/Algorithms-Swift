//
//  MergeSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/16.
//

import Foundation

// MARK: 归并排序
// 归并： 将两个有序数组合并成一个更大的有序数组
// 归并排序：要将一个数组排序，可以递归地将它分成两半排序，再归并起来
// 任意长度 N 的数组所需的时间和 NLogN 成正比，但是所需的额外空间和 N 称正比

// 实现归并最简单直接就是将两个有序数组归并到第三个数组中。
// 当时当数组变大，多次归并时每次都要产生一个新的数组来存储结果会需要很多额外空间。
// 因此有了原地归并的方法，先将前半段排序，再将后半段排序，在数组中移动元素而不需要使用额外的空间。

/// 原地归并的抽象方法
/// 将 array[low...mid] 和 array[mid+1...high] 归并
func merge<Item: Comparable>(_ array: inout [Item], low: Int, mid: Int, high: Int) {
    
    func less<Item: Comparable>(_ v: Item, to w: Item) -> Bool {
        return v < w
    }
    
    var i = low
    var j = mid + 1
    
    // 将 array 复制到 tempArr 中
    let tempArr = array
    // 再归并回 array 中
    for k in low...high {
        if (i > mid) { // 左半边用尽
            array[k] = tempArr[j]
            j += 1
        } else if j > high{ // 右半边用尽
            array[k] = tempArr[i]
            i += 1
        } else if less(tempArr[j], to: tempArr[i]) { // 右半边的当前元素小于左半边
            array[k] = tempArr[j]
            j += 1
        } else { // 左半边当前元素小于右半边
            array[k] = tempArr[i]
            i += 1
        }
    }
}


// MARK: 自动向下的归并排序 Merge
/// 自顶向下的归并排序
/// 这是一个应用 分治 思想的典型例子
/// 如果能够将两个子数组排序，那么就可以归并整个数组来排序
class Merge<Item: Comparable> {
    private var aux: [Item] = [Item]() // 辅助数组
    
    /// 自顶向下的归并排序
    /// - Returns: 排序好的数组
    func sort(_ array: inout [Item]) {
        aux = array // 一次性分配空间
        sort(&array, low: 0, high: array.count - 1)
    }
    
    /// 自顶向下的归并排序
    /// - Parameters:
    ///   - low: 数组的起始 index
    ///   - high: 数组的结束 index
    private func sort(_ array: inout [Item], low: Int, high: Int) {
        if high <= low { return }
        let mid = low + (high - low) / 2
        
        sort(&array, low: low, high: mid)             // 将左半边排序
        sort(&array, low: mid+1, high: high)          // 将右半边排序
        merge(&array, low: low, mid: mid, high: high) // 归并
    }
}
// 对于长度为 N 的数组，自顶向下的归并排序算法需要 1/2NlgN ～ NlgN 次比较
// 证明： 算法 第四版 P212

// 对于长度为 N 的数组，自顶向下的归并排序算法最多需要 6NlgN 次访问数组
// 每次归并最多需要访问数组 6N 次（2N 次用来复制，2N 次用来将排好序的元素移动回去，另外最多比较 2N 次）
// 另外根据上面的命题，即可得到这个命题的结果。

// 对小规模数组使用插入排序
// 使用不同的方法处理小规模问题能改善大多数递归算法的性能，因为递归会是小规模问题中方法的调用过于频繁，改进这一部分就能提升算法的性能。

// 可以添加一个判断，如果 array[mid] <= array[mid+1]，那么这两部分数组合起来也是有序的，可以跳过 merge() 操作
// 在这部分的运行时间就降为线性的了


extension Merge {
    func merge(_ array: inout [Item], low: Int, mid: Int, high: Int) {
        var i = low
        var j = mid + 1
        
        // 将 array 复制到 tempArr 中
        for index in low...high {
            aux[index] = array[index]
        }
        // 再归并回 array 中
        for k in low...high {
            if (i > mid) { // 左半边用尽
                array[k] = aux[j]
                j += 1
            } else if j > high{ // 右半边用尽
                array[k] = aux[i]
                i += 1
            } else if less(aux[j], to: aux[i]) { // 右半边的当前元素小于左半边
                array[k] = aux[j]
                j += 1
            } else { // 左半边当前元素小于右半边
                array[k] = aux[i]
                i += 1
            }
        }
    }
}

extension Merge {
    private func less<Item: Comparable>(_ v: Item, to w: Item) -> Bool {
        return v < w
    }
}


// MARK: 自底向上的归并排序 MergeBU - merge bottom up
/// 自底向上的归并排序
/// 自顶向下是将一个大问题分解成多个小问题，但实际中我们归并的数组可能都非常小。
/// 实现归并排序的另一种方法就是先将微型数组归并，再成对归并得到的数组
class MergeBU<Item: Comparable> {
    private var aux: [Item] = [Item]() // 归并需要的辅助数组
    
    func sort(_ array: inout [Item]) -> [Item] {
        let length = array.count
        aux = [Item](repeating: array[0], count: length)
        var size = 1 // 归并的数组的大小
        while size < length {
            for low in stride(from: 0, through: length - size, by: size + size) {
                merge(&array, low: low, mid: low + size - 1, high: min(low + size + size - 1, length - 1))
            }
            size += size // size = size * 2
        }
        return array
    }
}
// 对于长度为 N 的任意数组，自底向上的归并排序需要 1/2NlgN 至 NlgN 次比较，最多访问数组 6NlgN 次。
// 自底向上的归并排序比较适合用链表组织的数据，只需要重新组织链表的连接就能将链表原地排序。


extension MergeBU {
    private func merge(_ array: inout [Item], low: Int, mid: Int, high: Int) {
        var i = low
        var j = mid + 1
        
        // 将 array 复制到 tempArr 中
        for index in low...high {
            aux[index] = array[index]
        }
        // 再归并回 array 中
        for k in low...high {
            if (i > mid) { // 左半边用尽
                array[k] = aux[j]
                j += 1
            } else if j > high{ // 右半边用尽
                array[k] = aux[i]
                i += 1
            } else if less(aux[j], to: aux[i]) { // 右半边的当前元素小于左半边
                array[k] = aux[j]
                j += 1
            } else { // 左半边当前元素小于右半边
                array[k] = aux[i]
                i += 1
            }
        }
    }
}

extension MergeBU {
    private func less<Item: Comparable>(_ v: Item, to w: Item) -> Bool {
        return v < w
    }
}

