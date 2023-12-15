//
//  BreadthFirstSearch.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/26.
//

import Foundation


// 对于一些问题，如：从 s 到 v 是否存在一条路径，如果有，找出其中最短的那条。解决这个问题的经典方法叫做 广度优先搜索（BFS）
/// 广度优先搜索
class BreadthFirstPaths {
    private var marked: [Bool]  // 到达该顶点的最短路径是否已知
    private var edgeTo: [Int?]   // 到达该顶点的已知路径上的最后一个顶点
    private let source: Int     // 起点
    
    init(with graph: Graph, and source: Int) {
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        self.edgeTo = [Int?](repeating: nil, count: graph.vertexCount())
        self.source = source
    }
    
    /// 广度优先搜索
    private func bfs(_ graph: Graph, with v: Int) {
        let queue = QueueInArray<Int>()
        marked[v] = true
        queue.enqueue(v)
        while let vertex = queue.dequeue() {
            for nextVertex in graph.veticesAdjacent(to: vertex) {
                if marked[nextVertex] { continue }  // 如果已经标记过了，跳过
                edgeTo[nextVertex] = vertex
                marked[nextVertex] = true
                queue.enqueue(nextVertex)
            }
        }
    }
    
    func hasPathTo(_ vertex: Int) -> Bool { return marked[vertex] }
    
    func pathTo(_ vertex: Int) -> [Int]? {
        if !hasPathTo(vertex) { return nil }
        var temp = vertex
        var path = [Int]()
        while temp != source {
            path.insert(temp, at: 0)
            temp = edgeTo[temp]!
        }
        path.insert(temp, at: 0)
        return path
    }
}

/*
 对于从 s 可达的任意顶点 v，广度优先搜索都能找到一条从 s 到 v 的最短路径，不会存在其他从 s 到 v 的路径长度比这条路径更短
 */
