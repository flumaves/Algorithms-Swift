//
//  QuickSort.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/16.
//

import Foundation

// MARK: 快速排序
// 它是原地排序（只需要一个很小的辅助栈），长度为 N 的数组排序所需的时间和 NlgN 成正比
// 快速排序也是一种分治的算法，它将一个数组分成两个数组，两个部分独立地进行排序。
// 归并排序是将两个数组排序完再归并排序，这样整个数组就是有序的
// 而快速排序是当两个数组有序的时候，整个数组就有序了

/// 快速排序算法
/// usage：Quick().sort(&array)
class Quick<Item: Comparable> {
    func sort(_ array: inout [Item]) {
        sort(&array, low: 0, high: array.count - 1)
    }
    
    /// 快速排序算法
    /// - Parameters:
    ///   - low: 数组的起始 index
    ///   - high: 数组的终止 index
    private func sort(_ array: inout [Item], low: Int, high: Int){
        if high <= low { return }
        let j = partition(&array, low: low, high: high)
        sort(&array, low: low, high: j - 1)
        sort(&array, low: j + 1, high: high)
    }
    
    /// 分割数组
    /// - Parameters:
    /// - Returns: 分割点所在的 index
    private func partition(_ array: inout [Item], low: Int, high: Int) -> Int {
        // 将数组分割为 arr[lo...i-1], arr[i], arr[i+1...high]
        var i = low
        var j = high + 1
        let compare = array[low]
        
        while true {
            while less(array[i + 1], to: compare) {
                i += 1
                if i == high { break }
            }
            while less(compare, to: array[j - 1]) {
                j -= 1
                if j == low { break }
            }
            if i >= j { break }
            exch(&array, v: i, w: j)
        }
        // 将 compare 放入正确的位置
        exch(&array, v: low, w: j)
        return j
    }
    
    /// 交换数组中两个元素
    /// - Parameters:
    ///   - v: 元素 v 所在 index
    ///   - w: 元素 w 所在 index
    private func exch(_ array: inout [Item], v: Int, w: Int) {
        let temp = array[v]
        array[v] = array[w]
        array[w] = temp
    }
}
// 将长度为 N 的无重复数组重新排序，快速排序平均想要 ~2NlgN 次比较（以及 1/6 的交换）
// 快速排序有很多优点，但它的基本实现存在一个缺点：切分不平衡时，这个程序会极为低效。
// 所以在快速排序之前将数组随机排序就是为了防止这种情况，这一步操作能将糟糕的切分情况的概率降到极低
// 排序数组最多需要 N^2/2 次比较，但是随机打乱数组能够避免这种情况

extension Quick {
    private func less<Item: Comparable>(_ v: Item, to w: Item) -> Bool {
        return v < w
    }
}

// 算法改进：
// 1. 切换到插入排序
// 同大多数递归函数一样，对于小数组改用 插入排序 能够改进快速排序的性能
// 2. 三取样切分
// 使用子数组的一部分元素的中位数来切割数组，代价是需要计算中位数。取样大小为 3，且用中间大小的元素进行切分效果最好。
// 还可以在数组的结尾放置 sentinel 来去掉 partition() 中的数组边界测试

// 3. 熵最优的排序
// 当一个全是重复元素的子数组不需要重新排序了，但是算法依旧会将数组继续切分为更小的数组，这就有很大的改进潜力，将线性对数级别提升到线性级别
// 一种简单的想法是：将数组切分成三部分，小于、等于、大于切分元素的区间
// 它从左到右遍历数组一次，维护一个指针 lt 使得 a[lo..lt-1] 中的元素都小于 v，一个指针 gt 使得 a[gt+1..hi] 中的元素都大于 v，
// 一个指针 i 使得 a[lt..i-1] 中的元素都等于 v，a[i..gt] 中的元素都还未确定
//一开始 i 和 lo 相等，我们使用 Comparable 接口（而非 less()）对 a[i] 进行三项比较来直接处理以下情况：
// a[i] 小于 v，将 a[lt] 和 a[i] 交换，将 lt 和 i 加一；
// a[i] 大于 v，将 a[gt] 和 a[i] 交换，将 gt 减一；
// a[i] 等于 v，将 i 加一。
// 这些操作都会保证数组元素不变且缩小 gt-i 的值（这样循环才会结束）。另外，除非和切分元素相等，其他元素都会被交换。
// 具体算法如下
class Quick3Way<Item: Comparable> {
    func sort(_ array: inout [Item]) {
        sort(&array, low: 0, high: array.count - 1)
    }
    
    private func sort(_ array: inout [Item], low: Int, high: Int) {
        if high <= low { return }
        var lt = low
        var gt = high
        var i = low + 1
        let cmp = array[low]
        while i <= gt {
            if cmp < array[i] {
                exch(&array, v: i, w: gt)
                gt -= 1
            } else if cmp > array[i] {
                exch(&array, v: i, w: lt)
                lt += 1
                i += 1
            } else { // cmp == array[i]
                i += 1
            }
        }
        sort(&array, low: low, high: lt - 1)
        sort(&array, low: gt + 1, high: high)
    }
    
    private func exch(_ array: inout [Item], v: Int, w: Int) {
        let temp = array[v]
        array[v] = array[w]
        array[w] = temp
    }

}

