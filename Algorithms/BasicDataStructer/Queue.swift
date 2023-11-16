//
//  Queue.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/14.
//

import Foundation

// MARK: 先进先出队列（FIFO）

/// 数组实现队列
class QueueInArray<Item>: Sequence {
    private var items: [Item] = [Item]()
    private var count: Int = 0
    
    /// 创建空队列
    init() {}
    
    /// 添加一个元素
    func enqueue(_ item:Item) {
        items.append(item)
    }
    
    /// 删除最早添加的元素
    func dequeue() -> Item? {
        return items.removeFirst()
    }
    
    /// 队列是否为空
    func isEmpty() -> Bool {
        return count == 0 ? true : false
    }
    
    /// 队列中元素的数量
    func size() -> Int {
        return count
    }
    
    func makeIterator() -> QueueIterator {
        return QueueIterator(values: items)
    }
    
    struct QueueIterator: IteratorProtocol {
        private let values: [Item]
        private var index: Int?
        
        init(values: [Item]) {
            self.values = values
        }
        
        private func nextIndex(for index: Int?) -> Int? {
            if let index = index, index < values.count - 1 {
                return index + 1
            } else if index == nil, !values.isEmpty {
                return 0
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

/// 链表实现队列
class QueueInList<Item> {
    private var items: List<Item> = List<Item>()
    
    init() {}
    
    /// 添加一个元素
    func enqueue(_ item: Item) {
        items.addLast(item)
    }
    
    /// 删除最早添加的元素
    func dequeue() -> Item? {
        return items.removeFirst()
    }
    
    /// 队列是否为空
    func isEmpty() -> Bool {
        return items.isEmpty()
    }
    
    /// 队列中元素的数量
    func size() -> Int {
        return items.size()
    }
}
