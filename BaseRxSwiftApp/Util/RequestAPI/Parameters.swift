//
//  Parameters.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 6/8/25.
//

class Parameters {
    func toDictionary() -> [String: Any]? {
        var dict: [String: Any] = [:]
        let mirror = Mirror(reflecting: self)
        
        for (key, value) in mirror.children {
            if let key = key {
                dict[key] = value
            }
        }
        return dict
    }
}
