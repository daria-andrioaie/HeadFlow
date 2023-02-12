//
//  Coordinator.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation
import UIKit

public protocol Coordinator {
    var rootViewController: UIViewController? { get }
    func start(connectionOptions: UIScene.ConnectionOptions?)
}
