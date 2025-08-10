//
//  APIRepository.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 6/8/25.
//

import Foundation
import RxSwift

protocol APIRequest {
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    func body() throws -> Data?
}

extension APIRequest {
    func urlRequest() throws -> URLRequest {
        guard let url = URL(string: AppEnvironment.apiBaseURL + path) else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        if let params = parameters {
            request.addParameters(params, method: method)
        }
        if let bodyData = try body() {
            request.httpBody = bodyData
        }
        return request
    }
}

class APIRepository {
    private let session: URLSession
    
    private static let sharedUrlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }()
    
    init(session: URLSession = APIRepository.sharedUrlSession) {
        self.session = session
    }
    
    func request<T: Decodable>(
        endPoint: APIRequest,
        httpCodes: HTTPCodes = .success
    ) -> Single<T> {
        do {
            let request = try endPoint.urlRequest()
            logRequest(request)

            return Single<T>.create { [weak self] single in
                let task = self?.session.dataTask(with: request) { data, response, error in
                    if let error = error {
                        self?.logError("Network Error: \(error.localizedDescription)")
                        single(.failure(APIError.networkError(error)))
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse else {
                        single(.failure(APIError.unexpectedResponse))
                        return
                    }

                    self?.logResponse(httpResponse, data: data)

                    guard httpCodes.contains(httpResponse.statusCode) else {
                        single(.failure(APIError.serverError(httpResponse.statusCode)))
                        return
                    }

                    guard let data = data else {
                        single(.failure(APIError.noData))
                        return
                    }

                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        single(.success(decoded))
                    } catch let decodeError as DecodingError {
                        self?.logError("Decoding Error: \(decodeError)")
                        single(.failure(APIError.decodingError(decodeError)))
                    } catch {
                        self?.logError("Unknown Decoding Error: \(error)")
                        single(.failure(APIError.networkError(error)))
                    }
                }

                task?.resume()

                return Disposables.create {
                    task?.cancel()
                }
            }
        } catch {
            return Single.error(APIError.invalidRequest(error))
        }
    }

}

extension APIRepository {
    private func logRequest(_ request: URLRequest) {
        print("""
        📡 API Request:
        URL: \(request.url?.absoluteString ?? "Unknown URL")
        Method: \(request.httpMethod ?? "Unknown Method")
        Headers: \(request.allHTTPHeaderFields ?? [:])
        Body: \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No Body")
        """)
    }
    
    private func logResponse(_ response: URLResponse, data: Data?) {
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let responseBody = data.flatMap { String(data: $0, encoding: .utf8) } ?? "No Body"
        print("""
        ✅ API Response:
        URL: \(httpResponse.url?.absoluteString ?? "Unknown URL")
        Status Code: \(httpResponse.statusCode)
        Headers: \(httpResponse.allHeaderFields)
        Body: \(responseBody)
        """)
    }
    
    private func logError(_ message: String) {
        print("❌ API Error: \(message)")
    }
}
