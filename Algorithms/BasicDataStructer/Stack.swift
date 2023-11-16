//
//  Stack.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/14.
//

import Foundation

// MARK: 后进先出（LIFO）栈

/// 数组实现实现的栈
class StackInArray<Item>: Sequence {
    private var count: Int = 0 // 元素的个数
    private var items: [Item] = [Item]() // 使用数组实现
    
    /// 创建一个空栈
    init() {}
    
    /// 添加一个元素
    func push(_ item: Item) {
        items.append(item)
    }
    
    /// 删除最近添加的元素
    func pop() -> Item? {
        return items.removeLast()
    }
    
    /// 栈是否为空
    func isEmpty() -> Bool {
        return count == 0 ? true : false
    }
    
    /// 栈中的元素的数量
    func size() -> Int {
        return count
    }
    
    func makeIterator() -> StackIterator {
        return StackIterator(values: items)
    }
    
    struct StackIterator: IteratorProtocol {
        private let values: [Item]
        private var index: Int?
        
        init(values: [Item]) {
            self.values = values
        }
        
        private func nextIndex(for index: Int?) -> Int? {
            if let index = index, index > 0 {
                return index - 1
            } else if index == nil, !values.isEmpty {
                return self.values.count - 1
            }
            return nil
        }
        
        mutating func next() -> Item? {
            if let index = nextIndex(for: self.index) {
                self.index = index
                return self.values[index]
            }
            return nil
        }
    }
}

// swift 中数组的长度是可变的
// 在其他语言中，若是数组长度不可变，为了防止溢出，应当在 add 方法中添加一个 isFull() 判断是否溢出
// 如果将要溢出，那么就创建一个新的长度为 1.25 倍的数组，将原本的元素复制过去
// 如果数组过大，那么就将它长度减半，检测的条件为元素的数量小于数组的 1/4，这样减半后，数组为半满的状态，还能进行多次操作
// 这样栈永远不会溢出，使用率也不会低于 1/4


/// 用链表实现的栈
class StackInList<Item> {
    private var items: List<Item> = List<Item>()
    
    /// 创建一个空栈
    init() {}
    
    /// 添加一个元素
    func push(_ item: Item) {
        items.addLast(item)
    }
    
    /// 删除最近添加元素
    func pop() -> Item? {
        return items.removeLast()
    }
    
    /// 栈是否为空
    func isEmpty() -> Bool {
        return items.isEmpty()
    }
    
    /// 栈中元素的数量
    func size() -> Int {
        return items.size()
    }
}
