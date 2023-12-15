//
//  EdgeWeightGraph.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/12/4.
//

import Foundation

// 加权图是一种为每条边关联一个权值或是成本的图模型。

/*
 图的生成树是它的一棵含有所有丁点的无环连通子图
 一幅加权图的最小生成树（MST）是它的一棵权值（所有边的权值之和）最小的生成树
 */

// tips：
// 1. 只考虑连通图。如果一幅图是非连通的，只能使用最小生成树算法来计算所有连通分量的最小生成树，合并在一起称为最小生成森林
// 2. 边的权重不一定表示距离
// 3. 边的权重可能是 0 或是负数
// 4. 所有边的权重各不相同

/**
    图的一种切分是将图的所有的顶点分为两个非空且不重叠的两个集合。
    横切边是一条链接两个属于不同集合的边。
 
    切分定理：在一幅加权图中， 给定任意的切分，它的横切边中权重最小者必然属于图的最小生成树。
 */

/// 对边的定义
class Edge: Comparable {
    private let v: Int  // 其中一个顶点
    private let w: Int  // 另一个顶点
    /// 边的权重
    let weight: Double
    
    init(v: Int, w: Int, weight: Double) {
        self.v = v
        self.w = w
        self.weight = weight
    }
    
    /// 返回边的两端的顶点之一
    func either() -> Int { return v }
    
    /// 返回另一个顶点
    func other(_ vertex: Int) -> Int? {
        if vertex == v {
            return w
        } else if vertex == w {
            return v
        }
        return nil
    }
    
    static func < (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.weight < rhs.weight
    }
    
    static func == (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.weight == rhs.weight
    }
}


// Prim 算法
// 每一步都会为一棵生长中的树添加一条边。
// 一开始这棵树只有一个顶点，然后会向它添加 V-1 条边，每次总是将下一条连接树中的顶点与不在树中的顶点且权重最小的边加入树中。

/// 最小生成树（Prim 算法的延时实现）
class LazyPrimMST {
    private var marked: [Bool]              // 最小生成树的顶点
    private var mst: QueueInArray<Edge>     // 最小生成树的边
    private var pq: MinPQ<Edge>             // 横切边（包括失效的边）
    
    init(with graph: EdgeWeightedGraph) {
        self.pq = MinPQ()
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        self.mst = QueueInArray()
        
        visit(0, in: graph)
        while let edge = pq.delMin() {  // 在 pq 中得到权重最小的边
            let vertex = edge.either()
            let anotherVertex = edge.other(vertex)!
            
            if marked[vertex] && marked[anotherVertex] { continue } // 跳过失效的边
            mst.enqueue(edge)   // 将边添加到树中
            if !marked[vertex] {
                visit(vertex, in: graph)
            }
            if !marked[anotherVertex] {
                visit(anotherVertex, in: graph)
            }
        }
    }
    
    /// 标记顶点 v 并将所有连接 v 和未被标记顶点的边加入 pq
    private func visit(_ vertex: Int, in graph: EdgeWeightedGraph) {
        marked[vertex] = true
        for edge in graph.verteciesAdjacent(to: vertex) {
            if !marked[edge.other(vertex)!] { pq.insert(edge) }
        }
    }
    
    func edges() -> QueueInArray<Edge> {
        return mst
    }
}


// Kruskal 算法
// 思想是：按照边的权重顺序（从小到大）处理它们。将边加入最小生成树中，加入的边不会与已经加入的边构成环，直到树中有 V-1 条边为止。
// Kruskal 算法可以计算任意加权连通图的最小生成树

/// 最小生成树（Kruskal 算法）
class KruskalMST {
    private var mst: QueueInArray<Edge>
    
    init(with graph: EdgeWeightedGraph) {
        mst = QueueInArray()
        let pq = MinPQ<Edge>()
        let uf = UnionFind(graph.vertexCount())
        
        for edge in graph.edges() { pq.insert(edge) }
        while let edge = pq.delMin(), mst.size() < graph.vertexCount() - 1 {    // 从 pq 中得到权重最小的边和他的顶点
            let vertex = edge.either()
            let anotherVertex = edge.other(vertex)!
            if uf.isConnected(vertex, with: anotherVertex) { continue } // 边的两个顶点已经存在树中
            uf.union(vertex, with: anotherVertex)   // 合并分量
            mst.enqueue(edge)                       // 将边添加到最小生成树中
        }
    }
    
    func edges() -> QueueInArray<Edge> { return mst }
}
