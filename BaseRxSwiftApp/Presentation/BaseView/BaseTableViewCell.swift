//
//  BaseTableViewCell.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 9/8/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell, BaseType {
    // MARK: -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        
        initUI()
        updateUI()
        prepareForReuse()
    }

    deinit {
        print("===== Deinit class \(NSStringFromClass(self.classForCoder)) =====")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        binding()
    }

    func initUI() {
        backgroundView = UIView()
        selectedBackgroundView = UIView()
    }

    func updateUI() {
        updateStrings()
        selectedBackgroundView?.backgroundColor = .separator
    }

    func updateStrings() {}

    func binding() {}
}
