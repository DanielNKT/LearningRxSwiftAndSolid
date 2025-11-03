//
//  ProfileViewModel.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 11/8/25.
//

import RxSwift
import RxCocoa

final class ProfileViewModel: BaseViewModel {
    // OUTPUT
    var detailUser: Driver<User> { userRelay.asDriver().compactMap { $0 } }
    
    // STATE
    private let userRelay = BehaviorRelay<User?>(value: nil)
    
    // INPUT/TRIGGERS
    private let reloadRelay = PublishRelay<String>()   // better than PublishSubject here
    
    
    private let fetchUserUseCase: FetchDetailUserUseCase
    private let userName: String
    
    init(fetchUserUseCase: FetchDetailUserUseCase, userName: String) {
        self.fetchUserUseCase = fetchUserUseCase
        self.userName = userName
        super.init()
        self.binding()
    }
    private func binding() {
        reloadRelay
            .do(onNext: { [weak self] _ in self?.setLoading(true) })
            .flatMapLatest { [unowned self] name in
                self.fetchUserUseCase.execute(name: name)
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                self.setLoading(false)
                switch event {
                case .next(let user):
                    self.userRelay.accept(user)
                case .error(let err):
                    self.publishError(err.localizedDescription)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    func fetchDetailUser() {
        reloadRelay.accept(userName)
    }
}
