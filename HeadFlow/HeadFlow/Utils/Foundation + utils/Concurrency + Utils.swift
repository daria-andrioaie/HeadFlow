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

extension Task where Success == Never, Failure == Never {
    /// Suspends the current task for at least the given duration in seconds.
    static func sleep(seconds: TimeInterval) async {
        let duration = UInt64(seconds * 1_000_000_000)
        try? await sleep(nanoseconds: duration)
    }
}
