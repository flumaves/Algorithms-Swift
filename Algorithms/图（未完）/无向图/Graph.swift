//
//  Graph.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/26.
//

import Foundation

/*
 图是由一组顶点和一组能够将两个顶点相连的边组成的
 */

/**
 相关术语：
    自环：一条链接一个顶点和其自身的边
    平行边：链接同一对顶点的两条边
    相邻：当两个顶点通过一条边相连时，称这两个顶点是相邻的，并称这条边依附于这两个顶点
    度数：依附于某个顶点的边的总数
    子图：一幅图的所有边的一个子集（以及它们所依附的所有的顶点）
    路径：由边顺序连接的一系列顶点。简单路径是一条没有重复顶点的路径。环是一条至少含有一条边且起点和终点相同的路径。简单环是一条除了起点和终点相同，不含有重复顶点和边的环。
    长度：路径或环的长度为其中所包含的边数
    连通图：如果从任意一个顶点都存在一条路径到达另一个任意顶点，我们称这幅图是连通图
    图的密度：已经连接的顶点占所有可能被连接的顶点对的比例
    二分图：能够将所有结点分成两部分的图
 */

/**
 API 定义：
    func Graph(\_ v: Int)   // 创建一个含有 V 个顶点不含边的图
    func V() -> Int     // 顶点数
    func E() -> Int     // 边数
    func addEdge(from v: Int, to w: Int)    // 向图中添加一条边 v-w
    func adj(\_ v: Int) -> [Int]    //  和 v 相邻的所有顶点
 */


// 图的几种表示方法
/**
 邻接矩阵：
    用一个 V 乘 V 的布尔矩阵。当顶点 v 和顶点 w 之间有相连接的边时，定义 v 行 w 列的元素值为 true，否则为 false
    但是当顶点数非常多时，V^2 个布尔值的空间是不能满足的
    邻接矩阵无法表示平行边
 
 边的数组：
    使用一个 Edge 类，含有两个 int 实例变量。
    但是要实现 adj() 需要遍历图中所有的边
 
 邻接表数组：
    使用一个以顶点为索引的列表数组，其中每个元素都是和该顶点相邻的顶点列表
 */
/// 无向图的邻接表
class Graph {
    private var V: Int = 0  // 顶点数目
    private var E: Int = 0  // 边的数目
    private var adj: [Bag<Int>]  // 邻接表
    
    init(V: Int) {
        self.V = V
        self.adj = [Bag<Int>](repeating: Bag(), count: V)
    }
    
    /// 返回顶点的数量
    func vertexCount() -> Int {
        return V
    }
    
    /// 返回边的数量
    func edgeCount() -> Int {
        return E
    }
    
    /// 在点 v 和点 w 之间添加边
    func addEdge(_ v: Int, with w: Int) {
        adj[v].add(w)
        adj[w].add(v)
        E += 1
    }
    
    /// 返回与 v 相邻的所有顶点
    func adj(_ v: Int) -> Bag<Int> { return adj[v] }
}
