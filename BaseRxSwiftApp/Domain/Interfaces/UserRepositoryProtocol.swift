//
//  UserRepositoryProtocol.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import RxSwift

protocol UserRepositoryProtocol {
    func getListUsers(_ params: Parameters) -> Single<Users>
    func getUserDetail(name: String) -> Single<User>
}
