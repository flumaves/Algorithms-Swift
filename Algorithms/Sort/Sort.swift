//
//  Sort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

// 排序类算法模版
// item 需要遵守 comparable 协议，能够比较大小
class SortExample<Item: Comparable> {
    private var array: [Item]
    
    init(_ array: [Item]) {
        self.array = array
    }
    
    /// 对数组进行排序
    func sort() -> [Item] {
        // sort methods
        return self.array
    }
    
    /// 交换元素 v 和元素 w 的位置
    /// - Parameters:
    ///   - v: 元素 v 在数组中的 index
    ///   - w: 元素 w 在数组中的 index
    private func exch(_ v: Int, with w: Int) {
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
    
    /// 打印数组
    private func show(_ array: [Item]) {}
    
    /// 判断数组元素是否有序
    func isSorted(_ array: [Item]) -> Bool {
        for index in 1..<array.count {
            if !less(array[index-1], to: array[index]) { return false }
        }
        return true
    }
}

// usage:
// let sortedArray = SortExample(array).sort()

// MARK: 排序成本模型。
// 在研究排序算法时，需要比较 计算 和 交换 的数量。对于不交换元素的算法，比较访问数组的次数

// MARK: 额外内存使用
// 排序算法的额外内存开销和运行时间是同等重要的。
// 排序算法可以分为两类：
// 1.除了函数调用所需的栈和固定数目的实例变量之外无需额外内存的原地排序算法
// 2.需要额外内存空间来存储另一份数组副本的其他排序算法。
