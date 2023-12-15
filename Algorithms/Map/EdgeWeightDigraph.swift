//
//  EdgeWeightDigraph.swift
//  Algorithms
//
//  Created by xiong_jia on 2023/12/15.
//

import Foundation

/// Weighted directed edge.
struct DirectedEdge {
    let from: Int       // starting point of edge
    let to: Int         // end point of edge
    let weight: Double  // edge weight
}


/// Weighted directed graph based on adjacency list.
class EdgeWeightDigraph {
    private var V: Int = 0                  // number of vertices
    private var E: Int = 0                  // number of edges
    private var adj: [Bag<DirectedEdge>]    // adjacency list
    
    init(with vertexCount: Int) {
        self.V = vertexCount
        self.adj = [Bag<DirectedEdge>](repeating: Bag(), count: vertexCount)
    }
    
    /// Return number of vertices.
    func vertexCount() -> Int { return V }
    
    /// Return number of edges.
    func edgeCount() -> Int { return E }
    
    /// Add edge to the graph.
    func addEdge(_ edge: DirectedEdge) {
        adj[edge.from].add(edge)
        E += 1
    }
    
    /// Return all vertices adjacent to v.
    func verticesAdjacent(to vertex: Int) -> Bag<DirectedEdge> {
        return adj[vertex]
    }
    
    /// Return all directed edges in the graph.
    func edges() -> Bag<DirectedEdge> {
        let bag = Bag<DirectedEdge>()
        for vertex in adj {
            for edge in vertex {
                bag.add(edge)
            }
        }
        return bag
    }
}
