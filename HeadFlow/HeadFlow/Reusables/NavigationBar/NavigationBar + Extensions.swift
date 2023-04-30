//
//  NavigationBar + Extensions.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 30.04.2023.
//

import Foundation
import SwiftUI

extension NavigationBar where RightView == EmptyView {
    init(title: String? = nil,
         leftButtonAction: @escaping () -> Void) {
        self.title = title
        self.leftButtonAction = leftButtonAction
        self.rightView = EmptyView.init()
    }
}
