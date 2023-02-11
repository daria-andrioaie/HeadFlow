//
//  UserDefaults + property wrapper.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            let UDvalue = UserDefaults.standard.object(forKey: key) as? T
            switch (UDvalue as Any) {
            case Optional<Any>.some(let value):
                return value as! T
            case Optional<Any>.none:
                return defaultValue
            default:
                return UDvalue ?? defaultValue
            }
        }
        
        set {
            switch (newValue as Any) {
            case Optional<Any>.some(let value):
                UserDefaults.standard.set(value, forKey: key)
            case Optional<Any>.none:
                UserDefaults.standard.removeObject(forKey: key)
            default:
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}
