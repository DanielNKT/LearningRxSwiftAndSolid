//
//  UserUseCases.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import RxSwift

final class FetchListUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(params: UserListRequest) -> Single<Users> {
        return repository.getListUsers(params)
    }
}

final class FetchDetailUserUseCase {
    private let repository: UserRepositoryProtocol
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(name: String) -> Single<User> {
        return repository.getUserDetail(name: name)
    }
}

final class UserUseCases {
    
    let fetchUser: FetchListUserUseCase
    let fetchDetailUser: FetchDetailUserUseCase
        
    init(userRepository: UserRepositoryProtocol) {
        self.fetchUser = FetchListUserUseCase(repository: userRepository)
        self.fetchDetailUser = FetchDetailUserUseCase(repository: userRepository)
    }
}
