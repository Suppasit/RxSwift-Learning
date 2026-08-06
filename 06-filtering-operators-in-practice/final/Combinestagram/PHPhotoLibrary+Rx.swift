//
//  PHPhotoLibrary+Rx.swift
//  Combinestagram
//
//  Created by Suppasit Chuwatsawat on 31/7/2569 BE.
//  Copyright © 2569 BE Underplot ltd. All rights reserved.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
  @available(iOS 14, *)
  static var authorized: Observable<Bool> {
    return Observable.create { observer in
      DispatchQueue.main.async {
        if authorizationStatus() == .authorized {
          observer.onNext(true)
          observer.onCompleted()
        } else {
          observer.onNext(false)
          requestAuthorization(for: .readWrite) { newStatus in
            observer.onNext(newStatus == .authorized)
            observer.onCompleted()
          }
        }
      }
      return Disposables.create()
    }
  }
}
