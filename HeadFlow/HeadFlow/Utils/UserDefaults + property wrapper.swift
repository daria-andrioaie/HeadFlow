//
//  UserDefaults + property wrapper.swift
//  HeadFlow
//
//  Created by Daria Andrioaie on 11.02.2023.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data, let UDvalue = try? JSONDecoder().decode(T.self, from: data) {
                return UDvalue
            }
            return defaultValue
        }
        
        set {
            switch (newValue as Any) {
            case Optional<Any>.some(_):
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
            case Optional<Any>.none:
                UserDefaults.standard.removeObject(forKey: key)
            default:
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
            }
        }
    }
}
