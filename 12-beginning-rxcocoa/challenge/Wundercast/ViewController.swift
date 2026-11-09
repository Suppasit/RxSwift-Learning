/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private var searchCityName: UITextField!
    @IBOutlet private var tempLabel: UILabel!
    @IBOutlet private var humidityLabel: UILabel!
    @IBOutlet private var iconLabel: UILabel!
    @IBOutlet private var cityNameLabel: UILabel!
    
    private let bag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        style()
        
        let searchInput = searchCityName.rx
            .controlEvent(.editingDidEndOnExit)
            .map { [weak self] in self?.searchCityName.text ?? "" }
            .filter { !$0.isEmpty }
        
        let state = searchInput
            .startWith("bangkok")
            .flatMapLatest { text -> Observable<SearchState> in
                ApiController.shared
                    .currentWeather(for: text)
                    .map(SearchState.loaded)
                    .catchAndReturn(.loaded(.empty))
                    .startWith(.loading)
            }
            .asDriver(onErrorJustReturn: .loaded(.empty))
       
        let isLoading = state.map(\.isLoading)
        let weather = state.compactMap(\.weather)
        
        isLoading
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        isLoading
            .drive(cityNameLabel.rx.isHidden)
            .disposed(by: bag)
       
        weather.map { "\($0.temperature + 273)° K"}
            .drive(tempLabel.rx.text)
            .disposed(by: bag)
        
        weather.map(\.icon)
            .drive(iconLabel.rx.text)
            .disposed(by: bag)
        
        weather.map { "\($0.humidity)%" }
            .drive(humidityLabel.rx.text)
            .disposed(by: bag)
        
        weather.map(\.cityName)
            .drive(cityNameLabel.rx.text)
            .disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Appearance.applyBottomLine(to: searchCityName)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Style
    
    private func style() {
        view.backgroundColor = UIColor.aztec
        searchCityName.attributedPlaceholder = NSAttributedString(string: "City's Name",
                                                                  attributes: [.foregroundColor: UIColor.textGrey])
        searchCityName.textColor = UIColor.ufoGreen
        tempLabel.textColor = UIColor.cream
        humidityLabel.textColor = UIColor.cream
        iconLabel.textColor = UIColor.cream
        cityNameLabel.textColor = UIColor.cream
        
        // Required for Auto Layout; otherwise the zero-size autoresizing frame wins
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.style = .large

        NSLayoutConstraint.activate([
            activityIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

private enum SearchState {
    case loading
    case loaded(ApiController.Weather)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var weather: ApiController.Weather? {
        if case .loaded(let weather) = self { return weather }
        return nil
    }
}
