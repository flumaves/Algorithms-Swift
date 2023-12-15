//
//  Graph.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/26.
//

import Foundation

/// Undirected graph based on adjacency list.
class Graph {
    private var V: Int = 0          // number of vertices
    private var E: Int = 0          // number of edges
    private var adj: [Bag<Int>]     // adjacency list
    
    init(with vertexCount: Int) {
        self.V = vertexCount
        self.adj = [Bag<Int>](repeating: Bag(), count: V)
    }
    
    /// Return number of vertices.
    func vertexCount() -> Int {
        return V
    }
    
    /// Return number of edges.
    func edgeCount() -> Int {
        return E
    }
    
    /// Add an edge between v and w.
    func addEdge(between v: Int, and w: Int) {
        adj[v].add(w)
        adj[w].add(v)
        E += 1
    }
    
    /// Returns all vertices adjacent to v
    func veticesAdjacent(to v: Int) -> Bag<Int> {
        return adj[v]
    }
}
