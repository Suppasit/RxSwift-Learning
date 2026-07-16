//
//  SupportCode.swift
//  
//
//  Created by Suppasit Chuwatsawat on 15/7/2569 BE.
//
import Foundation

public func example(of description: String,
                    action: () -> Void) {
    print("\n--- Example of:", description, "---")
    action()
}
