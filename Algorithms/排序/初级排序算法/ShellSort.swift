//
//  ShellSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/16.
//

import Foundation

// MARK: 希尔排序
// 一种基于插入排序的快速排序算法
// 对于大规模的乱序数组来说，插入排序很慢，因为它只能交换相邻的元素，一步一步从数组一端移动到另一端
// 希尔排序为了加快速度简单地改进了插入排序，交换不相邻的元素来对数组进行局部排序，最终用插入排序将局部有序的数组排序

// 希尔排序使数组中任意间隔为 h 的元素是有序的，这样的数组称为 h 有序数组。即一个 h 有序数组是由 h 个互相独立的有序数组组成
class Shell<Item: Comparable> {
    func sort(_ array: inout [Item]) {
        var h = 1
        while h < array.count / 3 {
            h = 3 * h + 1
        }
        
        while h >= 1 {
            for i in h..<array.count {
                for j in stride(from: i, through: h, by: -h) {
                    if less(array[j-h], to: array[j]) { break }
                    exch(&array, j-h, with: j)
                }
            }
            h = h / 3
        }
    }
}
// 透彻理解希尔排序的性能依旧是个挑战，目前无法准确描述其对乱序数组的性能
// 但已知最坏的情况下，希尔排序的比较次数同 N^(3/2) 成正比

// 对于中等大小的数组，希尔排序的耗时可以接受而且不需要额外的内存空间
// 对于其他更复杂的算法，可能性能提升不到 2 倍，所以希尔排序是个不错的选择


// 模版方法
extension Shell {
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
