//
//  BaseView.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 9/8/25.
//

import UIKit
import RxSwift

class BaseView: UIView, BaseType {

    // MARK: - Views

    // MARK: -

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        print("===== Init class \(NSStringFromClass(self.classForCoder)) =====")

        initUI()
        updateUI()
        binding()
    }

    deinit {
       print("===== Deinit class \(NSStringFromClass(self.classForCoder)) =====")
    }

    func initUI() {
    }

    func updateUI() {
        updateStrings()
    }

    func updateStrings() {}

    func binding() {
        
    }

}
