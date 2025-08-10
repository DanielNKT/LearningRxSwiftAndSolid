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
    
    private lazy var tableView = UITableView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        $0.estimatedRowHeight = 100
    }
    
    override func initUI() {
        super.initUI()
        
        self.view.addSubview(tableView)
        tableView.constraintsTo(view: self.view, position: .full)
        setupTableview()
        
        viewModel.fetchUsers()
    }
    
    private func setupTableview(){
        // create observable
        viewModel.items
            .drive(tableView.rx.items(cellIdentifier: "UserCell", cellType: UserCell.self)) { _, user, cell in
                cell.configCell(user: user)
            }
            .disposed(by: bag)
    }
}
