//
//  DispatchQueue + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

extension DispatchQueue {
    public func asyncAfter(seconds: Double, execute: @escaping () -> Void) {
        asyncAfter(deadline: .now() + seconds, execute: execute)
    }
}
