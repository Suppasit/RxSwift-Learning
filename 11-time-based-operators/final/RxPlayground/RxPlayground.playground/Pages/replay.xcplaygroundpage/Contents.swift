//: [Previous](@previous)

import UIKit
import RxSwift


// Start coding here
let elementsPersecond = 1
let maxElements = 58
let replayElements = 1
let replayDelay: TimeInterval = 3

//let sourceObservable = Observable<Int>.create { observer in
//    var value = 1
//    let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPersecond), queue: .main) {
//        if value <= maxElements {
//            observer.onNext(value)
//            value += 1
//        }
//    }
//    
//    return Disposables.create {
//        timer.suspend()
//    }
//}
//    .replay(replayElements)
//    .replayAll()

let sourceObservalbe = Observable<Int>
    .interval(.milliseconds(Int(1000.0 / Double(elementsPersecond))), scheduler: MainScheduler.instance)
    .replay(replayElements)

let sourcetimeline = TimelineView<Int>.make()
let replayedTimeline = TimelineView<Int>.make()
let stack = UIStackView.makeVertical([
    UILabel.makeTitle("replay"),
    UILabel.make("Emit \(elementsPersecond) per second:"),
    sourcetimeline,
    UILabel.make("Replay \(replayElements) after \(replayDelay) sec:"),
    replayedTimeline
])
_ = sourceObservalbe.subscribe(sourcetimeline)

DispatchQueue.main.asyncAfter(deadline: .now() + replayDelay) {
    _ = sourceObservalbe.subscribe(replayedTimeline)
}
_ = sourceObservalbe.connect()

let hostView = setupHostView()
hostView.addSubview(stack)
hostView

// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, @preconcurrency ObserverType where E: CustomStringConvertible {
    static func make() -> TimelineView<E> {
        return TimelineView(width: 400, height: 100)
    }
    public func on(_ event: Event<E>) {
        switch event {
        case .next(let value):
            add(.next(String(describing: value)))
        case .completed:
            add(.completed())
        case .error(_):
            add(.error())
        }
    }
}

//: [Next](@next)
