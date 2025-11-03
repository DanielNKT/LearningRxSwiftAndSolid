//
//  HomeViewModel.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    var items: Driver<Users> { itemsRelay.asDriver() }
    
    private let itemsRelay = BehaviorRelay<[User]>(value: [])
    private let usersSubject = PublishSubject<UserListRequest>()
    
    private let useCases: UserUseCases
    private var since: Int = 0
    
    init(useCases: UserUseCases) {
        self.useCases = useCases
        super.init()
        bind()
    }
    
    func fetchUsers(perPage: Int = 20, page: Int = 0) {
        let params = UserListRequest()
        params.per_page = perPage
        params.since = self.since
        usersSubject.onNext(params)
    }
    
    private func bind() {
        usersSubject
            .do(onNext: { [weak self] _ in self?.setLoading(true) })
            .flatMapLatest { [unowned self] params in
                self.useCases.fetchUser
                    .execute(params: params)          // Single<[User]>
                    .map { ($0, params.per_page) }    // ([User], Int)
                    .asObservable()
                    .materialize()
            }
            .subscribe(onNext: { [weak self] event in
                guard let self = self else { return }
                self.setLoading(false)
                switch event {
                case .next(let (users, perPage)):
                    let current = self.itemsRelay.value

                        // keep only users whose id isn’t already present
                        let uniqueIncoming = users.filter { newUser in
                            !current.contains(where: { $0.id == newUser.id })
                        }

                        if self.since == 0 {
                            // first page -> replace (still dedup just in case)
                            self.itemsRelay.accept(uniqueIncoming)
                            self.since = perPage + 1
                        } else {
                            // next page -> append uniques
                            self.itemsRelay.accept(current + uniqueIncoming)
                            self.since += perPage
                        }
                case .error(let err):
                    self.publishError(err.localizedDescription)
                case .completed:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
