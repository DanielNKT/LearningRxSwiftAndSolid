//
//  BaseType.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseType where Self: UIResponder {
    func initUI()
    func updateUI()
    func updateStrings()
    func binding()
}

protocol BindableType where Self: UIResponder {
    associatedtype ViewModelType: BaseViewModel
    var viewModel: ViewModelType! { get set }
}

extension BindableType {
    func bind(_ viewModel: Self.ViewModelType) -> Self {
        self.viewModel = viewModel
        return self
    }
}

class BaseViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    // Common state
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let errorRelay = PublishRelay<String>()
    
    // Common outputs
    var isLoading: Driver<Bool> { loadingRelay.asDriver() }
    var error: Signal<String> { errorRelay.asSignal() }
    
    // Protected API for subclasses
    func setLoading(_ loading: Bool) {
        loadingRelay.accept(loading)
    }
    
    func publishError(_ message: String) {
        errorRelay.accept(message)
    }
}

extension UIAppearance {
    public func style(_ styleClosure: (Self) -> Void) -> Self {
        styleClosure(self)
        return self
    }
}
