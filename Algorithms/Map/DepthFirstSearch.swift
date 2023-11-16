//
//  DepthFirstSearch.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/26.
//

import Foundation


/// 深度优先搜索寻路
class DepthFirstSearch {
    private var marked: [Bool]  // 某个顶点上是否调用过 dfs()
    private var edgeTo: [Int?]   // 从起点到一个顶点的已知路径的最后一个顶点
    private let source: Int     // 起点
    private var count: Int = 0  // 与起点相连的点的数量

    init(with graph: Graph, with source: Int) {
        self.source = source
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        self.edgeTo = [Int?](repeating: nil, count: graph.vertexCount())
        dfs(graph, with: source)
    }
    
    /// 深度优先搜索
    private func dfs(_ graph: Graph, with v: Int) {
        marked[v] = true
        count += 1
        for nextVertex in graph.adj(v) {
            if !marked[nextVertex] {
                edgeTo[nextVertex] = v
                dfs(graph, with: nextVertex)
            }
        }
    }
    
    /// 返回是否存在路径从起点 s 到顶点 v
    func hasPathTo(_ v: Int) -> Bool { return marked[v] }
    
    /// 返回从起点 s 到顶点 v 的路径
    func pathTo(_ v: Int) -> [Int]? {
        if !hasPathTo(v) { return nil }
        var temp = v
        var path = [Int]()
        while temp != source {
            path.insert(temp, at: 0)
            temp = edgeTo[temp]!
        }
        path.insert(temp, at: 0)
        return path
    }
    
    func adjCount() -> Int {
        return count
    }
}



// 连通分量
// 深度优先搜索的下一个应用就是找出一幅图中所有的连通分量
// connecting components
class CC {
    private var marked: [Bool]
    private var id: [Int?]
    private var count: Int = 0
    
    init(with graph: Graph) {
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        self.id = [Int?](repeating: nil, count: graph.vertexCount())
        
        for vertex in 0..<graph.vertexCount() {
            if marked[vertex] { continue }
            dfs(graph, with: vertex)
            count += 1
        }
    }
    
    func dfs(_ graph: Graph, with v: Int) {
        marked[v] = true
        id[v] = count
        for nextVertext in graph.adj(v) {
            if marked[nextVertext] { continue }
            dfs(graph, with: nextVertext)
        }
    }
    
    /// 返回顶点 v 和顶点 w 是否在同一个连通分量里面
    func isConnected(_ v: Int, with w: Int) -> Bool {
        return id[v] == id[w]
    }
    
    /// 返回连通分量的数量
    func CCCount() -> Int { return count }
}
