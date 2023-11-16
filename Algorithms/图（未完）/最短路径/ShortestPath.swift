//
//  ShortestPath.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/12/5.
//

import Foundation

// 最短路径问题都可以归纳为：找到从一个顶点到另一个顶点的成本最小的路径
// 在一幅加权有向图中，从顶点 s 到顶点 t 的最炫路径是所有从 s 到 t 的路径中的权重最小者

// 单点路径问题；给定一幅加权有向图和一个起点 s，找出到顶点 v 的最短的路径

/*
 最短路径树：
    给定一幅加权有向图和一个顶点 s，以 s 为起点的一棵最短路径树是图的一幅子图，包含 s 和从 s 可达的所有顶点。
    这棵树的根结点为 s，树的每条路径都是有向图中的一条最短路径。
 */


/// 加权有向边
struct DirectedEdge {
    let from: Int       // 边的起点
    let to: Int         // 边的终点
    let weight: Double  // 边的权重
}


/// 加权有向图
class EdgeWeightDigraph {
    private var V: Int      // 顶点总数
    private var E: Int      // 边的总数
    private var adj: [Bag<DirectedEdge>]    // 邻接表
    
    /// 创建含有 vertexCount 个顶点的空有向图
    init(with vertexCount: Int) {
        self.V = vertexCount
        self.E = 0
        self.adj = [Bag<DirectedEdge>](repeating: Bag(), count: vertexCount)
    }
    
    /// 返回顶点的总数
    func vertexCount() -> Int { return V }
    
    /// 返回边的总数
    func edgeCount() -> Int { return E }
    
    /// 添加边 e 到该有向图中
    func addEdge(_ edge: DirectedEdge) {
        adj[edge.from].add(edge)
        E += 1
    }
    
    /// 从 v 中指出的边
    func adj(_ vertex: Int) -> Bag<DirectedEdge> { return adj[vertex] }
    
    /// 该图中的所有有向边
    func edges() -> Bag<DirectedEdge> {
        let bag = Bag<DirectedEdge>()
        for vertex in 0..<vertexCount() {
            for edge in adj[vertex] { bag.add(edge) }
        }
        return bag
    }
}

/*
 最优性条件：
    令 G 为一幅加权有向图，顶点 s 是 G 中的起点，distTo[] 是一个由顶点索引的数组，保存的是 G 中路径的长度。
    对于从 s 可达的所有顶点 v，distTo[v] 的值是从 s 到 v 的某条路径的长度，对于从 s 不可达的所有顶点 v，该值为无穷大。
    当且仅当对于从 v 到 w 的任意一条边 e，这些值都满足 distTo[w] <= distTo[v] + e.weight() 时，它们是最短路径的长度
 */

// Dijkstra 算法
// 将 distTo[s] 初始化为 0，distTo[] 中其他元素初始化为 正无穷，然后将 distTo[] 最小的非树顶点放松并加入树中
// 重复操作直到所有的顶点都在树中或者所有的非树顶点的 distTo[] 均值为无穷大

// Dijkstra 算法能够解决边权重非负的加权有向图的单起点最短路径问题
// 在一幅含有 V 个顶点和 E 条边的加权有向图中，使用 Dijkstra 算法计算根结点为给定起点的最短路径树所需的空间和 V 成正比，时间与 ElogV 成正比。
