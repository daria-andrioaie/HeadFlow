//
//  Collections + Utils.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 20.02.2023.
//

import Foundation

extension StringProtocol {
    subscript(safe offset: Int) -> String? {
        0 <= offset && offset < count ? String(self[index(startIndex, offsetBy: offset)]) : nil
    }
}

extension Collection where Indices.Iterator.Element == Index {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
