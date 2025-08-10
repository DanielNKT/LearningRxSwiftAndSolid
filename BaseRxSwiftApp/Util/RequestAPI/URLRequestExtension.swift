//
//  URLRequestExtension.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 7/8/25.
//
import Foundation

extension URLRequest {
    mutating func addParameters(_ parameters: Parameters?, method: HTTPMethod) {
        guard let params = parameters, let dicParams = params.toDictionary() else { return }
        if method == .GET {
            guard var urlComponents = URLComponents(url: self.url!, resolvingAgainstBaseURL: false) else { return }
            urlComponents.queryItems = dicParams.map { URLQueryItem(name: $0.key, value: "\($0.value)")}
            self.url = urlComponents.url
        } else {
            self.httpBody = try? JSONSerialization.data(withJSONObject: dicParams)
            self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
