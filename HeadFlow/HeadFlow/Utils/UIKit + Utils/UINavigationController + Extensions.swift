//
//  UINavigationController + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 17.02.2023.
//

import Foundation
import UIKit
import SwiftUI

extension UINavigationController {
    func pushHostingController<Content: View>(rootView: Content, animated: Bool = false) {
        let VC = UIHostingController(rootView: rootView)
        self.pushViewController(VC, animated: animated)
    }
}
