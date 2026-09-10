import RxSwift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Start coding here!
example(of: "Challenge 1 - solution using zip") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let scanObservable = source.scan(0, accumulator: +)
    let zipObservable = Observable.zip(source, scanObservable) { source, result in
        return "\(source): \(result)"
    }
    _ = zipObservable.subscribe(onNext: { value in
        print(value)
    })
}

example(of: "Challenge 1 - using just scan and tuple") {
    let source = Observable.of(1, 3, 5, 7, 9)
    let observable = source.scan((0, 0)) { acc, current in
        return (current, acc.1 + current)
    }
    _ = observable.subscribe(onNext: { tuple in
        print("\(tuple.0): \(tuple.1)")
    })
}
