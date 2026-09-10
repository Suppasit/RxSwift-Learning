import RxSwift
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Start coding here!
example(of: "scan") {
  let source = Observable.of(1, 3, 5, 7, 9)

  let observable = source.scan(0, accumulator: +)
  _ = observable.subscribe(onNext: { value in
    print(value)
  })
}
