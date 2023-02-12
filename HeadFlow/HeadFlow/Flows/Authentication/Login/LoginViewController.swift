//
//  LoginViewController.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 12.02.2023.
//

import Foundation
import SwiftUI

extension Login {
    class ViewController: UIHostingController<ContentView> {
        let viewModel: ViewModel
        
        init() {
            self.viewModel = ViewModel()
            super.init(rootView: ContentView(viewModel: viewModel))
        }
        
        @objc required dynamic init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
