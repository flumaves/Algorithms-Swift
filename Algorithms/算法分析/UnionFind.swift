//
//  UnionFind.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

// 输入一系列整数，当 p 和 q 是等价的时候，我们称 p、q 是相连的，且具有一下特性
// 1. 自反性： p 和 p 是相连的
// 2. 对称性： p 和 q 相连，那么 q 和 p 相连
// 3. 传递性： p 和 q 相连，q 和 r 相连，那么 p 和 r 相连

// 用于处理动态连通性问题
// 下面将对象称为触点，整数对称称为连接，将等价类称为连通分量/分量

// 需要的 API 和定义如下
class UnionFind {
    private var numberOfUnion: Int // 连通分量的数量
    private var id: [Int]          // 分量 id，以触点作为索引
    private var size: [Int]        // 触点指向的分量的大小，只有 weightedQuickUnion 方法需要该属性
    
    // 初始化
    // 以整数 0～N-1 初始化 N 个触点
    init(_ size: Int) {
        self.numberOfUnion = size
        var array = [Int]()
        for i in 0..<size {
            array.append(i)
        }
        self.id = array
        // weightedQuickUnion 方法 only
        let size = [Int](repeating: 1, count: size)
        self.size = size
    }
    
    // 判断 p、q 两个触点是否在同一个分量中
    // 如果是，返回 true
    func isConnected(_ p: Int, with q: Int) -> Bool {
        return find(p) == find(q)
    }
    
    // 返回连通分量的数量
    func count() -> Int {
        return numberOfUnion
    }
    
    // 下面两个方法不同的算法实现不同
    // 连接两个触点，在 p、q 之间建立一条连接
    // 其余方法基本没有改变的空间，该方法的多种实现看下面 extension，这里调用效率较高的 weightedQuickUnion 算法
    func union(_ p: Int, with q: Int) {
        return unionWithWeightedQuickUnino(p, with: q)
    }
    
    // 返回触点 p 所在的分量
    func find(_ p: Int) -> Int {
        return findWithWeightedQuickUnion(p )
    }
}


// quick-find 算法
extension UnionFind {
    func findWithQuickFind(_ p: Int) -> Int {
        return id[p]
    }
    
    func unionWithQuickFind(_ p: Int, with q: Int) {
        // 获取 p、q 的连通分量的值
        let pID = findWithQuickFind(p)
        let qID = findWithQuickFind(q)
        
        // 如果相同直接返回
        if pID == qID { return }
        
        // 如果不同，需要遍历一遍数组将 q 所在的分量的所有触点的值设置为 p
        for index in 0..<id.count {
            if id[index] == qID {
                id[index] = pID
            }
        }
        
        // 连通分量数量建议
        numberOfUnion -= 1
    }
    // 根据分析，find() 操作只需访问数组一次，unino() 操作访问数组次数在 (N+3)~(2N+1) 之间
    // 调用数组的 2 次，遍历数组中 if 的 N 次，修改数组中元素的 1 ~ N-1 次，即 (2+N)+1 ～ (2+N)+(N-1) -> N+3~2N+1
    // 假设使用上述算法解决问题最后得到一个连通分量，那么至少调用 N-1 次 union()，即最少 (N+3)(N-1) ~ N^2 次数组访问
    // 所以该算法是平方级别的，只适用于 N 较小的情况
}


// quick-union 算法
// id[] 中的每一个元素都是同一分量中另一个触点的名称
extension UnionFind {
    func findWithQuickUnion(_ p: Int) -> Int {
        // 找到分量中的根结点
        var temp = p
        while (temp != id[temp]) {
            temp = id[temp]
        }
        return temp
    }
    // find() 方法最优情况访问一次数组，最坏的情况访问 2N+1 次数组
    
    func unionWithQuickUnion(_ p: Int, with q: Int) {
        // 找到对应的根结点
        let pRoot = findWithQuickUnion(p)
        let qRoot = findWithQuickUnion(q)
        
        if pRoot == qRoot { return }
        
        id[qRoot] = pRoot
        numberOfUnion -= 1
    }
    // unino 方法将两个分量合并的操作优化成了操作 1 次完成
    // 技术上说，id[] 使用父链接形成了一个森林
}
// quick-union 算法可以看作 quick-find 算法的改良，解决了 quick-find 中的主要问题（ union 方法是线性的）
// 但并不能保证 quick-union 算法在所有情况下都比 quick-find 算法更快
// 大致可以猜测，分量的这颗树🌲的形状也接近链表，那么这个算法的效率就越低


// 加权 quick-union 算法
// 为了防止上述糟糕的情况出现，现在需要记录树的大小，并将较小的树连接到较大的树上
// 需要添加一个数组和一些代码来记录树中的节点树
// 最坏的情况下，每个分量的大小是相等的，加权 quick-union 算法也能保证对数级别的性能
extension UnionFind {
    func findWithWeightedQuickUnion(_ p: Int) -> Int {
        // 找到分量的根结点
        var temp = p
        while (temp != id[temp]) {
            temp = id[temp]
        }
        return temp
    }
    
    func unionWithWeightedQuickUnino(_ p: Int, with q: Int) {
        // 找到对应的根结点
        let pRoot = findWithWeightedQuickUnion(p)
        let qRoot = findWithWeightedQuickUnion(q)
        
        if pRoot == qRoot { return }
        
        // 将小树连接到大树的根结点
        if size[pRoot] < size[qRoot] {
            id[pRoot] = qRoot
            size[qRoot] += size[pRoot]
        } else {
            id[qRoot] = pRoot
            size[pRoot] += size[qRoot]
        }
        
        numberOfUnion -= 1
    }
    // 对于 N 个触点，加权 quick-union 算法构造的森林中任意节点的深度最多为 lgN
    // 对于加权 quick-union 算法，find()、conected() 和 union() 的成本增长数量级为 logN
}

// 加权 quick-union 算法是三种算法中唯一可以解决大型实际问题的算法
// 实际中已经很难对 weighted-quick-union 算法进行改进了，虽然还有一个 使用路径压缩的加权 quick-union 算法，数量级接近 1 但没有达到 1
