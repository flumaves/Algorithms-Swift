//
//  Bag.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/14.
//

import Foundation

// MARK：Bag 背包
// 背包是一种不支持从中删除元素的数据类型，它的目的就是帮助用例收集元素

class Bag<Item>: Sequence {
    private var items: [Item] = [Item]()
    private var count: Int = 0
    
    /// 创建一个空背包
    init() {}
    
    /// 添加一个元素
    func add(_ item: Item) {
        items.append(item)
    }
    
    /// 返回背包是否为空
    func isEmpty() -> Bool {
        return count == 0 ? true : false
    }
    
    /// 返回背包中元素的数量
    func size() -> Int {
        return count
    }
    
    func makeIterator() -> BagIterator {
        return BagIterator(self.items)
    }
    
    struct BagIterator: IteratorProtocol {
        private var index: Int?
        private let values: [Item]
        
        init(_ values: [Item]) {
            self.values = values
        }
        
        private func nextIndex(for index: Int?) -> Int? {
            if let index = index, index < self.values.count - 1 {
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
