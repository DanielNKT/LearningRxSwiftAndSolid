//
//  AppEnviroment.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 7/8/25.
//

import Foundation

enum ConfigKey: String {
    case
        ENVIRONMENT,
        API_BASE_URL
}
enum AppEnvironment: String {
    case DEV, PRD
    
    private static subscript(key: ConfigKey) -> String {
        guard let result = Bundle.main.object(forInfoDictionaryKey: key.rawValue) as? String else {
            assertionFailure("Can not find value for key '\(key)', please check *.xcconfig")
            return ""
        }
        return result
    }

    static var current: AppEnvironment {
        return AppEnvironment(rawValue: AppEnvironment[.ENVIRONMENT]) ?? .PRD
    }

    static var apiBaseURL: String {
        return AppEnvironment[.API_BASE_URL]
    }
}
