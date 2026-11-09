//
//  Timer.swift
//  
//
//  Created by Suppasit Chuwatsawat on 8/10/2569 BE.
//

import Foundation

public extension DispatchSource {
    class func timer(interval: Double, queue: DispatchQueue, handler: @escaping () -> Void) -> DispatchSourceTimer {
        let source = DispatchSource.makeTimerSource(queue: queue)
        source.setEventHandler(handler: handler)
        source.schedule(deadline: .now(), repeating: interval, leeway: .nanoseconds(0))
        source.resume()
        return source
    }
}
