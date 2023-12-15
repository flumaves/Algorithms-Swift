//
//  EdgeWeightGraph.swift
//  Algorithms
//
//  Created by xiong_jia on 2023/12/15.
//

import Foundation

/// Weighted graph based on adjacency list.
class EdgeWeightedGraph {
    private var V: Int = 0          // number of vertecies
    private var E: Int = 0          // number of edges
    private var adj: [Bag<Edge>]    // adjacency list
    
    init(with vertexCount: Int) {
        self.V = vertexCount
        self.adj = [Bag<Edge>](repeating: Bag(), count: vertexCount)
    }
    
    /// return number of vertecies
    func vertexCount() -> Int {
        return self.V
    }
    
    /// return number of edges
    func edgeCount() -> Int {
        return self.E
    }
    
    /// Add an edge to graph
    func addEdge(_ edge: Edge) {
        let vertex = edge.either()
        let anotherVertex = edge.other(vertex)!
        adj[vertex].add(edge)
        adj[anotherVertex].add(edge)
        E += 1
    }
    
    /// Returns all vertices adjacent to v.
    func verteciesAdjacent(to vertex: Int) -> Bag<Edge> {
        return adj[vertex]
    }
    
    /// Return all edges in the graph.
    func edges() -> Bag<Edge> {
        let list = Bag<Edge>()
        for vertex in 0..<V {
            for edge in adj[vertex] {
                if edge.other(vertex)! > vertex {
                    list.add(edge)
                }
            }
        }
        return list
    }
}
