//
//  SelectionSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

// MARK: 选择排序
// 一种最简单的排序算法：
// 首先，找出数组中最小的元素
// 其次，将它和数组中的第一个元素交换位置。
// 再次，在剩下的元素中找到最小的元素与数组的第二个元素交换位置
// 如此往复，直到整个数组排序
// 之所以叫做选择排序，因为它在不断地选择数组中的最小的元素
// usage: let sortedArray = Selection(array).sort()
class Selection<Item: Comparable> {
    /// 对数组进行排序
    func sort(_ array: inout [Item]) {
        for i in 0..<array.count {
            var minIndex = i // 最小的元素所在的下标
            for j in i+1..<array.count {
                if array[j] < array[minIndex] { minIndex = j }
            }
            exch(&array, i, with: minIndex)
        }
    }
}
// 对于长度为 N 的数组，选择排序需要大约 N^2/2 次比较和 N 次交换
// 这是一种简单的排序算法，它有两个鲜明的特点
// 1. 运行时间和输入无关，为了找出最小的元素并不能为下一次扫描提供信息，即使是一个有序的数组耗费的时间也和无序数组耗费一样的时间
// 2. 数据移动是最少的，对于长度为 N 的数组，交换次数至多为 N，而其余排序算法的数量级为 线性对数 或是 平方级别


// 模版方法
extension Selection {
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
