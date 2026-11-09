//
//  HostView.swift
//  
//
//  Created by Suppasit Chuwatsawat on 8/10/2569 BE.
//

import UIKit
import PlaygroundSupport

@MainActor public func setupHostView() -> UIView {
  
  let hostView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 640))
  hostView.backgroundColor = .white

  PlaygroundPage.current.needsIndefiniteExecution = true
  PlaygroundPage.current.liveView = hostView
  
  return hostView
}
