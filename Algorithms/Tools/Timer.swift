//
//  Timer.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

// 计时器，用于计算某段函数执行操作耗时
// usage： let timer = Timer()
//         // long running task
//         print("This task took \(timer.stop) seconds.")
class Timer {
    private let startTime: CFAbsoluteTime = CFAbsoluteTimeGetCurrent()
    private var endTime: CFAbsoluteTime?
    
    var duration: CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
    
    // 停止计时
    func stop() -> CFAbsoluteTime {
        self.endTime = CFAbsoluteTimeGetCurrent()
        return duration!
    }
}
