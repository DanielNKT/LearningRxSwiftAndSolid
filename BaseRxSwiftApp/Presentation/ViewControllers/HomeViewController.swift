//
//  HomeViewController.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, BindableType {
    var viewModel: HomeViewModel!
    private let bag = DisposeBag()
    private let settingsBarButtonItem = UIBarButtonItem().style {
        $0.image = UIImage(systemName: "gear")
        $0.tintColor = .black
    }
    private lazy var tableView = UITableView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        $0.estimatedRowHeight = 100
        $0.separatorStyle = .none
    }
    
    override func initUI() {
        super.initUI()
        
        self.view.addSubview(tableView)
        tableView.constraintsTo(view: self.view, position: .full)
        setupTableview()
        viewModel.fetchUsers()
        self.title = "Home"
        self.navigationItem.rightBarButtonItem = settingsBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ✅ Setup Navigation Bar with large title when appear
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func binding() {
        super.binding()
        
        settingsBarButtonItem.rx.tap
            .asSignal(onErrorSignalWith: .empty())
            .emit(onNext: { [weak self] in
                let vc = SettingsViewController().bind(SettingsViewModel())
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
    private func setupTableview(){
        // create observable
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self)) { _, user, cell in
                cell.configCell(user: user)
                cell.selectionStyle = .none
            }
            .disposed(by: bag)
        
        tableView.rx.modelSelected(User.self)
            .subscribe(onNext: { [weak self] user in
                let vm = ProfileViewModel(fetchUserUseCase: FetchDetailUserUseCase(repository: UserRepository(apiRepositpory: APIRepository())), userName: user.login ?? "")
                let vc = ProfileViewController().bind(vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
}
