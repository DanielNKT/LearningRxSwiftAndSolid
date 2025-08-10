//
//  UserRepository.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import Foundation
import RxSwift

class UserRepository: UserRepositoryProtocol {
  
    private let apiRepository: APIRepository
    
    init(apiRepositpory: APIRepository) {
        self.apiRepository = apiRepositpory
    }
    
    func getListUsers(_ params: Parameters) -> Single<Users> {
        if AppEnvironment.current == .DEV {
            return returnMockUsersData()
        }
        return apiRepository.request(endPoint: UserEndpoint.listUser(params))
    }
    
    func getUserDetail(name: String) -> Single<User> {
        return apiRepository.request(endPoint: UserEndpoint.getUser(name: name))
    }
    
}

extension UserRepository {
    enum UserEndpoint {
        case listUser(Parameters?)
        case getUser(name: String)
    }
}

extension UserRepository.UserEndpoint: APIRequest {
    var parameters: Parameters? {
        switch self {
        case .listUser(let request):
            return request
        case .getUser:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .listUser:
            return "/users"
        case .getUser(let name):
            let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return "/users/\(encodedName ?? name)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .listUser, .getUser:
            return HTTPMethod.GET
        }
    }
    
    var headers: [String : String]? {
        //return ["Accept": "application/json", "Authorization" : "Your Template Token"]
        return nil
    }
    
    func body() throws -> Data? {
        return nil
    }
}

extension UserRepository {
    func returnMockUsersData() -> Single<Users> {
        return Single.create { single in
            do {
                let data = try JsonLoader.loadJSON(from: "Users") // returns Data
                let users = try JSONDecoder().decode(Users.self, from: data)
                single(.success(users))
            } catch {
                single(.failure(APIError.unexpectedResponse))
            }
            return Disposables.create()
        }
    }
}
