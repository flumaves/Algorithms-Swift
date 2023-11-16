//
//  Digraph.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/27.
//

import Foundation

/*
    有向图定义： 一副有方向性的图是由一组顶点和一组有方向的边组成的，每条有方向的边都连接着有序的一对顶点。
    出度：一个顶点的出度为由该顶点指出的边的总数
    入度：指向该顶点的边的总数
    一条有向边的第一个顶点称为它的头，第二个顶点称为它的尾
 */

class Digraph {
    private var V: Int      // 顶点数
    private var E: Int = 0  // 边数
    private var adj: [Bag<Int>]
    
    init(with V: Int) {
        self.V = V
        self.adj = [Bag<Int>](repeating: Bag(), count: V)
    }
    
    func edgeCount() -> Int { return E }
    
    func vertexCount() -> Int { return V }
    
    /// 添加从顶点 v 到顶点 w 的有向边
    func addEdge(from v: Int, to w: Int) {
        adj[v].add(w)
        E += 1
    }
    
    func adj(_ vertext: Int) -> Bag<Int> { return adj[vertext] }
    
    /// 返回一个将所有边反向的图
    func reverse() -> Digraph {
        let newGraph = Digraph(with: V)
        for vertex in 0..<V {
            for nextVertex in adj[vertex] {
                newGraph.addEdge(from: nextVertex, to: vertex)
            }
        }
        return newGraph
    }
}


// 有向图中的可达性
/**
    单点可达性：
    是否存在一条从 source 到达给定顶点 vertex 的有向路径
 
    多点可达性：
    是否存在一条从集中的任意顶点到达给定顶点 vertex 的有向路径
 
 在有向图中，DFS 标记由一个集合的顶点可达的所有顶点所需的时间与被标记的所有顶点的出度之和成正比
 */
class DirectedDFS {
    private var marked: [Bool]
    
    init(with graph: Graph, and source: Int) {
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        dfs(graph, from: source)
    }
    
    /// 从 vertex 开始深度优先搜索
    private func dfs(_ graph: Graph, from vertex: Int) {
        marked[vertex] = true
        for nextVertex in graph.adj(vertex) {
            if marked[nextVertex] { continue }
            dfs(graph, from: nextVertex)
        }
    }
    
    func marked(_ vertex: Int) -> Bool { return marked[vertex] }
}


// 优先级限制下的调度问题
// 对于一组给定任务以及关于任务完成先后次序的优先级限制，在满足限制条件的前提下应该如何安排并完成所有任务？
// 对于这样的问题，可以立马画出一张有向图，其中顶点对应任务，有向边对应优先级顺序，这样问题等价于另一个问题
/*
 拓扑排序：
    给定一副有向图，将所有的顶点排序，使得所有有向边均从排在前面的元素指向排在后面的元素
 */
/*
 有向环检测：
    如果给定的有向图中包含有向环，那么问题是无解的。需要检查这种错误。
 */

/// 检查图中是否存在环
class DirectedCycle {
    private var marked: [Bool]
    private var edgeTo: [Int?]
    private var cycle: StackInArray<Int> = StackInArray()
    private var onStack: [Bool]
    
    init(with graph: Graph) {
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        self.edgeTo = [Int?](repeating: nil, count: graph.vertexCount())
        self.onStack = [Bool](repeating: false, count: graph.vertexCount())
        for vertex in 0..<graph.vertexCount() {
            if marked[vertex] { continue }
            dfs(graph, to: vertex)
        }
    }
    
    /// 查找一条由起点到 v 的有向路径
    private func dfs(_ graph: Graph, to vertex: Int) {
        onStack[vertex] = true
        marked[vertex] = true
        for nextVertex in graph.adj(vertex) {
            if hasCycle() { return }
            if !marked[nextVertex] {
                edgeTo[nextVertex] = vertex
                dfs(graph, to: nextVertex)
            } else if onStack[nextVertex] {
                var temp = vertex
                while vertex != nextVertex {
                    cycle.push(temp)
                    temp = edgeTo[temp]!
                }
                cycle.push(nextVertex)
                cycle.push(vertex)
            }
        }
        onStack[vertex] = false
    }
    
    /// 返回图中是否存在环
    func hasCycle() -> Bool { return self.cycle.isEmpty() }
    
    /// 返回环的所有结点
    func cyclePath() -> StackInArray<Int> {
        return cycle
    }
}

// 拓扑排序
// 当且仅当一副有向图是无环图时它才能进行拓扑排序


/// 有向图中基于深度优先搜索的顶点排序
class DepthFirstOrder {
    private var marked: [Bool]
    private var pre: QueueInArray<Int>              // 所有顶点的前序排列
    private var post: QueueInArray<Int>             // 所有顶点的后序排列
    private var reversePost: StackInArray<Int>      // 所有顶点的拟后序排列
    
    init(with graph: Graph) {
        self.pre = QueueInArray()
        self.post = QueueInArray()
        self.reversePost = StackInArray()
        self.marked = [Bool](repeating: false, count: graph.vertexCount())
        
        for vertex in 0..<graph.vertexCount() {
            if marked[vertex] { continue }
            dfs(graph, and: vertex)
        }
    }
    
    
    private func dfs(_ graph: Graph, and vertex: Int) {
        pre.enqueue(vertex)
        
        marked[vertex] = true
        for nextVertex in graph.adj(vertex) {
            if marked[nextVertex] { continue }
            dfs(graph, and: nextVertex)
        }
        
        post.enqueue(vertex)
        reversePost.push(vertex)
    }
    
    func preOrder() -> QueueInArray<Int> {
        return pre
    }
    
    func postOrder() -> QueueInArray<Int> {
        return post
    }
    
    func reversePostOrder() -> StackInArray<Int> {
        return reversePost
    }
}


/// 拓扑排序
class Topological {
    private var order: StackInArray<Int>? // 顶点的拓扑排序
    
    init(with graph: Graph) {
        let cycleFinder = DirectedCycle(with: graph)
        if !cycleFinder.hasCycle() {
            let dfs = DepthFirstOrder(with: graph)
            self.order = dfs.reversePostOrder()
        }
    }
    
    /// 返回图的拓扑排序
    func topoOrder() -> StackInArray<Int>? {
        return self.order
    }
    
    /// 是否为有向无环图
    func isDAG() -> Bool { return order != nil }
}
// 一幅有向无边图的拓扑排序即为所有顶点的逆后序排序
// 使用深度优先搜索对有向无环图进行拓扑排序所需的时间和 V + E 成正比
// 更为流行的一种方法是使用队列储存顶点的更加直观的算法

/*
 有向图中的强连通性：
    一幅有向图中，如果顶点 v 和顶点 w 是互相可达的，则称它们为强连通的。即既存在一条从 v 到 w 的有向路径，也存在一条从 w 到 v 的有向路径。
    如果一幅有向图中的任意两个顶点都是强连通的，则称这幅有向图也是强连通的。
 */
