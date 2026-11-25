//
//  CLLocationManager+Rx.swift
//  Wundercast
//
//  Created by Suppasit Chuwatsawat on 16/11/2569 BE.
//  Copyright © 2569 BE Ray Wenderlich. All rights reserved.
//

import CoreLocation
import RxSwift
import RxCocoa

extension CLLocationManager: @retroactive HasDelegate {}

class RXCLLocationManagerDelegateProxy: DelegateProxy<CLLocationManager, CLLocationManagerDelegate>, DelegateProxyType, CLLocationManagerDelegate {
    weak public private(set) var locationManager: CLLocationManager?
    
    public init(locationManager: ParentObject) {
        self.locationManager = locationManager
        super.init(parentObject: locationManager,
                   delegateProxy: RXCLLocationManagerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { RXCLLocationManagerDelegateProxy(locationManager: $0) }
    }
}

public extension Reactive where Base: CLLocationManager {
    var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
        RXCLLocationManagerDelegateProxy.proxy(for: base)
    }
    
    var didUpdateLocations: Observable<[CLLocation]> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
            .map { parameters in
                parameters[1] as! [CLLocation]
            }
    }
    
    var authorizationStatus: Observable<CLAuthorizationStatus> {
        delegate.methodInvoked(#selector(CLLocationManagerDelegate.locationManagerDidChangeAuthorization(_:)))
            .map { parameters in
                (parameters[0] as! CLLocationManager).authorizationStatus
            }
            .startWith(base.authorizationStatus)
    }
    
    func getCurrentLocation() -> Observable<CLLocation> {
        let location = authorizationStatus
            .filter { $0 == .authorizedWhenInUse || $0 == .authorizedAlways } // 1
            .flatMap { _ in self.didUpdateLocations.compactMap(\.first) } // 2
            .take(1) // 3
            .do(onDispose: { [weak base] in base?.stopUpdatingLocation() })
        
        base.requestWhenInUseAuthorization()
        base.startUpdatingLocation()
        
        return location
    }
}
