//
//  UIWindow + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import UIKit

extension UIWindow {
    func transitionViewController(_ viewController: UIViewController) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) { [weak self] in
            self?.rootViewController = viewController
        }
    }
}
