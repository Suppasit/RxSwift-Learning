//
//  CLGeocoder+Rx.swift
//  Wundercast
//
//  Created by Suppasit Chuwatsawat on 23/11/2569 BE.
//  Copyright © 2569 BE Ray Wenderlich. All rights reserved.
//

import RxSwift
import RxCocoa
import MapKit

extension Reactive where Base: CLLocation {
    func cityName() -> Observable<String> {
        if #available(iOS 26.0, *) {
            return mapKitCityName()
        } else {
            return legacyCityName()
        }
    }
    
    @available(iOS 26.0, *)
    private func mapKitCityName() -> Observable<String> {
        Observable.create { [base] observer  in
            guard let request = MKReverseGeocodingRequest(location: base) else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            request.getMapItems { mapItems, error in
                if let error {
                    observer.onError(error)
                    return
                }
                if let city = mapItems?.first?.addressRepresentations?.cityName {
                    observer.onNext(city)
                }
                observer.onCompleted()
            }
            return Disposables.create { request.cancel() }
        }
    }
    
    private func legacyCityName() -> Observable<String> {
        Observable.create { [base] observer in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(base) { placemarks, error in
                if let error {
                    observer.onError(error)
                    return
                }
                if let city = placemarks?.first?.locality {
                    observer.onNext(city)
                }
                observer.onCompleted()
            }
            return Disposables.create { geocoder.cancelGeocode() }
        }
    }
}
