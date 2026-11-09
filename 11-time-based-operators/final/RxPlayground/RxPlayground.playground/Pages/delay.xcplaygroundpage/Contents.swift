//: [Previous](@previous)

import UIKit
import RxSwift

let elementsPerSecond = 1
let delay: RxTimeInterval = .milliseconds(1500)

let sourceObservable = PublishSubject<Int>()

let sourceTimeline = TimelineView<Int>.make()
let delayedTimeline = TimelineView<Int>.make()

let stack = UIStackView.makeVertical([
    UILabel.makeTitle("========="),
    UILabel.makeTitle("delay"),
    UILabel.make("Emitted elements (\(elementsPerSecond) per sec.):"),
    sourceTimeline,
    UILabel.make("Delayed elements (with a \(delay)s delay):"),
    delayedTimeline
])

var current = 1
let timer = DispatchSource.timer(interval: 1.0 / Double(elementsPerSecond), queue: .main) {
    sourceObservable.onNext(current)
    current = current + 1
}

_ = sourceObservable.subscribe(sourceTimeline)


// Setup the delayed subscription

// This delay will emit the element after the 2nd element has emitted
//_ = sourceObservable
//    .delaySubscription(delay, scheduler: MainScheduler.instance)
//    .subscribe(delayedTimeline)

// This delay will emit the element at exactly 1.5 seconds
//_ = sourceObservable
//    .delay(delay, scheduler: MainScheduler.instance)
//    .subscribe(delayedTimeline)

_ = Observable<Int>
    .timer(.seconds(3), scheduler: MainScheduler.instance)
    .flatMap { _ in
        sourceObservable.delay(delay, scheduler: MainScheduler.instance)
    }
    .subscribe(delayedTimeline)


// Start coding here



let hostView = setupHostView()
hostView.addSubview(stack)
hostView


// Support code -- DO NOT REMOVE
class TimelineView<E>: TimelineViewBase, @preconcurrency ObserverType where E: CustomStringConvertible {
    static func make() -> TimelineView<E> {
        let view = TimelineView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        view.setup()
        return view
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
