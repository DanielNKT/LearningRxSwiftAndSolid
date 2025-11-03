//
//  ProfileViewController.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 11/8/25.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseViewController, BindableType {
    let bag = DisposeBag()
    
    var viewModel: ProfileViewModel!
    var testButton = UIButton().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.text = "Test Button"
    }
    
    let userView = UserView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }
    
    override func initUI() {
        super.initUI()
        view.addSubview(userView)
        userView.constraintsTo(view: view, position: .top, constant: 4)
        userView.constraintsTo(view: view, position: .left, constant: 8)
        userView.constraintsTo(view: view, position: .right, constant: -8)
        
        view.addSubview(testButton)
        testButton.width(100)
        testButton.height(40)
        
        viewModel.fetchDetailUser()
    }
    override func binding() {
        super.binding()
        viewModel.detailUser
                .drive(onNext: { [weak self] user in
                    print("call success ........")
                    self?.configUserView(user: user)
                })
                .disposed(by: bag)
        
        testButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.fetchDetailUser()
            })
            .disposed(by: bag)
        
        testButton.rx.tap
            .bind { [weak self] in
                self?.viewModel.fetchDetailUser()
            }
            .disposed(by: bag)
    }
    func configUserView(user: User) {
        userView.labelName.text = user.name ?? user.login
        userView.labelHtml.text = user.htmlURL ?? "unknown"
        if let urlString = user.avatarURL, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            userView.imgView.image = UIImage(systemName: "person.crop.circle")
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self, let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.userView.imgView.image = image
                self.userView.imgView.circleView()
            }
        }.resume()
    }
}

class SearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let textField = UITextField()
    private let resultLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindSearch()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        textField.borderStyle = .roundedRect
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0

        let stack = UIStackView(arrangedSubviews: [textField, resultLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }

    private func bindSearch() {
        textField.rx.text.orEmpty
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance) // wait for typing pause
            .distinctUntilChanged() // only new values
            .flatMapLatest { query in
                return API.search(query: query) // call API
            }
            .asDriver(onErrorJustReturn: "Error")
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

// 🔹 Simulated API
struct API {
    static func search(query: String) -> Observable<String> {
        guard !query.isEmpty else {
            return Observable.just("No query")
        }

        // Simulate a network delay
        return Observable<String>.create { observer in
            print("➡️ API request for:", query)
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                observer.onNext("Result for \"\(query)\"")
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
