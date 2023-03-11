//
//  UIApplication + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.03.2023.
//

import Foundation
import UIKit

extension UIApplication {
    func tryOpen(url: URL?) {
        guard let url, canOpenURL(url) else {
            return
        }
        self.open(url)
    }
}
