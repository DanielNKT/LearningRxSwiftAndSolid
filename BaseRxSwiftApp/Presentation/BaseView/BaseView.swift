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

extension UIView {
    enum CircleType {
        case circle
        case number(CGFloat)
    }
   
    func addSubviews(_ views: UIView...) {
            views.forEach { addSubview($0) }
        }
    
    func addShadow(
        color: UIColor = .gray,
        opacity: Float = 0.3,
        offset: CGSize = CGSize(width: 2, height: 2),
        radius: CGFloat = 3)
    {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
    
    func addShadowAndRadius(
        color: UIColor = .gray,
        opacity: Float = 0.3,
        offset: CGSize = CGSize(width: 2, height: 2),
        radius: CGFloat = 3,
        radiusCircle: CircleType = .circle
    ) {
        self.layer.masksToBounds = false
        switch radiusCircle {
        case .circle:
            self.layer.cornerRadius = self.frame.width / 2
        case .number(let r):
            self.layer.cornerRadius = r
        }
        self.layer.shadowColor = color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    func circleView(radius: CircleType = .circle) {
        switch radius {
        case .circle:
            self.layer.cornerRadius = self.frame.width / 2
        case .number(let r):
            self.layer.cornerRadius = r
        }
        self.clipsToBounds = true
    }
}
