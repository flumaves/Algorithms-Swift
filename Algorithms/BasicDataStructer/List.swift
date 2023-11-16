//
//  List.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/14.
//

import Foundation

// MARK: 链表
// 链表是一种递归的数据结构，它或者为空 null，或者指向一个结点 node
// 该结点含有一个泛型的元素和一个指向另一条链表的引用
class List<Item> {
    // 结点
    private class Node {
        var item: Item? // sentinel item is equal nil
        var next: Node?
        var last: Node?
        
        init(_ item: Item, next: Node, last: Node) {
            self.item = item
            self.next = next
            self.last = last
        }
        
        init() {}
    }
    
    private var sentinel: Node
    private var count: Int = 0
    
    init() {
        let node = Node()
        node.last = node
        node.next = node
        self.sentinel = node
    }
}

// searchMethods
extension List {
    // 表头结点
    func first() -> Item? {
        if count == 0 { return nil }
        return sentinel.next!.item
    }
    
    // 末尾结点
    func last() -> Item? {
        if count == 0 { return nil }
        return sentinel.last!.item
    }
    
    // 特定位置结点
    func item(at index: Int) -> Item? {
        if index + 1 > count { return nil }
        var temp = sentinel
        for _ in 0...index {
            temp = temp.next!
        }
        return temp.item
    }
    
    // 是否为空
    func isEmpty() -> Bool {
        return count == 0 ? true : false
    }
    
    // 链表中元素的数量
    func size() -> Int {
        return count
    }
}

// addMethods
extension List {
    // 在表头插入结点
    func addFirst(_ item: Item) {
        let temp = sentinel.next!
        let newNode = Node(item, next: temp, last: sentinel)
        temp.last = newNode
        sentinel.next = newNode
        
        count += 1
    }
    
    // 在特定位置插入结点
    func insert(_ item: Item, at index: Int) {
        if index + 1 > count { return }
        var temp = sentinel
        for _ in 0...index {
            temp = temp.next!
        }
        let newNode = Node(item, next: temp, last: temp.last!)
        temp.last!.next = newNode
        temp.last = newNode
    }
    
    // 在表尾添加结点
    func addLast(_ item: Item) {
        let temp = sentinel.last!
        let newNode = Node(item, next: sentinel, last: temp)
        temp.next = newNode
        sentinel.last = newNode
        
        count += 1
    }
}

// deleteMethods
extension List {
    // 删除表头结点
    func removeFirst() -> Item? {
        if count == 0 { return nil }
        let node = sentinel.next!
        sentinel.next = node.next
        count -= 1
        return node.item
    }
    
    // 删除特定位置结点
    func removeAt(_ index: Int) -> Item? {
        if count < index + 1 { return nil }
        var temp = sentinel
        for _ in 0...index {
            temp = temp.next!
        }
        temp.last!.next = temp.next!
        temp.next!.last = temp.last!
        return temp.item
    }
    
    // 删除末尾结点
    func removeLast() -> Item? {
        if count == 0 { return nil }
        let node = sentinel.last!
        sentinel.last = node.last
        count -= 1
        return node.item
    }
}
