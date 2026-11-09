//
//  Label.swift
//  
//
//  Created by Suppasit Chuwatsawat on 8/10/2569 BE.
//

import UIKit

extension UILabel {
  public class func make(_ title: String) -> UILabel {
    let label = UILabel()
    label.text = title
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    return label
  }
  
  public class func makeTitle(_ title: String) -> UILabel {
    let label = make(title)
    label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 2.0)
    label.textAlignment = .center
    return label
  }
}
