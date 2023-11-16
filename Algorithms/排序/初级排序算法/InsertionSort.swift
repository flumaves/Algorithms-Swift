//
//  InsertionSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

// MARK: 插入排序
// 类似于整理排序，将一张牌插入到已经排序好的数组当中
// 在计算机的实现中，为了给要插入的元素腾空间，需要将后面的元素向右👉移动一位
class Insertion<Item: Comparable> {
    func sort(_ array: inout [Item]) {
        for i in 1..<array.count {
            for j in (1...i).reversed() {
                if less(array[j-1], to: array[j]) { break }
                exch(&array, j-1, with: j)
            }
        }
    }
    
    // 如果想要大幅提升插入排序的速度，只需要在内循环中将较大的元素向右👉移动而不是总是交换两个元素。（这样能让访问数组的次数减半）
    func sortOptimize(_ array: inout [Item]) {
        for i in 1..<array.count {
            let temp = array[i]
            for j in (1...i).reversed() {
                if less(array[j-1], to: array[j]) {
                    array[j] = temp
                    break
                }
                array[j] = array[j-1]
            }
        }
    }
}
// 对于长度为 N 且主键不重复的数组，平均情况下插入排序需要 ～N^2/4 次比较以及 ～N^2/4 次交换。
// 最坏的情况需要 ～N^2/2 次比较以及 ~N^2/2 次交换
// 最好的情况需要 N-1 次比较以及 0 次交换

// 对于部分有序数组（数组中倒置的数量小于数组大小的某个倍数，那么称这个数组是部分有序的），下面是几种典型的部分有序数组
// 1. 数组中每个元素离它最终位置不远
// 2. 一个有序大数组接一个小数组
// 3. 数组中只有几个元素位置不正确
// 插入排序对这样的数组很有效，当倒置的数量很少时，插入排序可能比其他排序算法快。

// 插入排序需要交换的操作和数组中倒置的数量相同，需要的比较次数大于等于倒置的数量，小于等于倒置的数量加上数组的大小减 1

// 模版方法
extension Insertion {
    /// 交换元素 v 和元素 w 的位置
    /// - Parameters:
    ///   - v: 元素 v 在数组中的 index
    ///   - w: 元素 w 在数组中的 index
    private func exch(_ array: inout [Item], _ v: Int, with w: Int) {
        let temp = array[v]
        array[v] = array[w]
        array[w] = temp
    }
    
    /// 判断元素 v 是否小于元素 w
    /// - Parameters:
    /// - Returns: if v < w, return true
    private func less(_ v: Item, to w: Item) -> Bool {
        return v < w
    }
    
    /// 判断数组元素是否有序
    func isSorted(_ array: [Item]) -> Bool {
        for index in 1..<array.count {
            if !less(array[index-1], to: array[index]) { return false }
        }
        return true
    }
}
