//
//  Timer.swift
//  Algorithms
//
//  Created by xiong_jia on 2022/11/15.
//

import Foundation

/// Timer, used to calculate the time it takes to execute a certain function
class Timer {
    func measureTime(_ task: () -> Void) -> CFAbsoluteTime {
        let startTime = CFAbsoluteTimeGetCurrent()
        task()
        let endTime = CFAbsoluteTimeGetCurrent()
        return endTime - startTime
    }
}
