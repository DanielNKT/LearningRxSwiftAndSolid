//
//  ConstraintByCoding.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import UIKit

extension UIView {
    enum RelationContraint {
        case equal
        case greaterOrEqual
        case lessOrEqual
    }
    enum OptionsContraint: Int {
        case full = 0
        case left
        case right
        case bottom
        case top
        case leftTop
        case leftBottom
        case rightTop
        case rightBottom
        case centerX
        case centerY
        case above
        case below
        case centerView
        case width
        case height
        case rightToLeft
        case leftToRight
        case topToBottom
        case bottomToTop
        case fullCover
    }
    /// Helper: create a constraint between two anchors
    func makeConstraint<T: AnyObject>(
        from first: NSLayoutAnchor<T>,
        to second: NSLayoutAnchor<T>,
        constant: CGFloat,
        relation: RelationContraint
    ) -> NSLayoutConstraint {
        switch relation {
        case .equal:
            return first.constraint(equalTo: second, constant: constant)
        case .greaterOrEqual:
            return first.constraint(greaterThanOrEqualTo: second, constant: constant)
        case .lessOrEqual:
            return first.constraint(lessThanOrEqualTo: second, constant: constant)
        }
    }
    
    func constraintsTo(view: UIView, position: OptionsContraint = .full, constant: Double = 0.0, relationContraint: RelationContraint = .equal) {
        
        switch position {
        case .full:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.trailingAnchor, to: view.safeAreaLayoutGuide.trailingAnchor, constant: constant, relation: relationContraint)
            ])
        case .fullCover:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.topAnchor, to: view.topAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.bottomAnchor, to: view.bottomAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.leadingAnchor, to: view.leadingAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.trailingAnchor, to: view.trailingAnchor, constant: constant, relation: relationContraint)
            ])
        case .left:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: constant, relation: relationContraint)
            ])
        case .right:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.trailingAnchor, to: view.safeAreaLayoutGuide.trailingAnchor, constant: constant, relation: relationContraint)
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint)
            ])
        case .top:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint)
            ])
        case .leftTop:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint)
            ])
        case .leftBottom:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.leadingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint)
            ])
        case .rightTop:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.rightAnchor, to: view.safeAreaLayoutGuide.rightAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint)
            ])
        case .rightBottom:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.rightAnchor, to: view.safeAreaLayoutGuide.rightAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint)
            ])
        case .centerX:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.centerXAnchor, to: view.safeAreaLayoutGuide.centerXAnchor, constant: constant, relation: relationContraint)
            ])
        case .centerY:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.centerYAnchor, to: view.safeAreaLayoutGuide.centerYAnchor, constant: constant, relation: relationContraint)
            ])
        case .above:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint)
            ])
        case .below:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint)
            ])
        case .centerView:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.centerXAnchor, to: view.safeAreaLayoutGuide.centerXAnchor, constant: constant, relation: relationContraint),
                makeConstraint(from: self.centerYAnchor, to: view.safeAreaLayoutGuide.centerYAnchor, constant: constant, relation: relationContraint)
            ])
        case .width:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.widthAnchor, to: view.safeAreaLayoutGuide.widthAnchor, constant: constant, relation: relationContraint)
            ])
        case .height:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.heightAnchor, to: view.safeAreaLayoutGuide.heightAnchor, constant: constant, relation: relationContraint)
            ])
        case .rightToLeft:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.trailingAnchor, to: view.safeAreaLayoutGuide.leadingAnchor, constant: constant, relation: relationContraint)
            ])
        case .leftToRight:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.leadingAnchor, to: view.safeAreaLayoutGuide.trailingAnchor, constant: constant, relation: relationContraint)
            ])
        case .topToBottom:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.topAnchor, to: view.safeAreaLayoutGuide.bottomAnchor, constant: constant, relation: relationContraint)
            ])
        case .bottomToTop:
            NSLayoutConstraint.activate([
                makeConstraint(from: self.bottomAnchor, to: view.safeAreaLayoutGuide.topAnchor, constant: constant, relation: relationContraint)
            ])
        }
    }
    
    func width(_ constant: Double, relationContraint: RelationContraint = .equal) {
        switch relationContraint {
        case .equal:
            self.widthAnchor.constraint(equalToConstant: constant).isActive = true
        case .greaterOrEqual:
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        case .lessOrEqual:
            self.widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
        }
    }
    
    func equalWidthItem(view: UIView, multiplier: CGFloat = 1.0) {
        self.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
    }
    
    func height(_ constant: Double, relationContraint: RelationContraint = .equal) {
        switch relationContraint {
        case .equal:
            self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        case .greaterOrEqual:
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        case .lessOrEqual:
            self.heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
        }
    }
    
    func equalHeightItem(view: UIView, multiplier: CGFloat = 1.0) {
        self.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier).isActive = true
    }
    
    func size(_ constant: Double, relationContraint: RelationContraint = .equal) {
        switch relationContraint {
        case .equal:
            self.widthAnchor.constraint(equalToConstant: constant).isActive = true
            self.heightAnchor.constraint(equalToConstant: constant).isActive = true
        case .greaterOrEqual:
            self.widthAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
        case .lessOrEqual:
            self.widthAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
            self.heightAnchor.constraint(lessThanOrEqualToConstant: constant).isActive = true
        }
    }
    
    func constraintsTo(view: UIView, positions: [OptionsContraint], constant: Double = 0.0, relationContraint: RelationContraint = .equal) {
        view.translatesAutoresizingMaskIntoConstraints = false
        positions.forEach {
            constraintsTo(view: view, position: $0, constant: constant, relationContraint: relationContraint)
        }
    }
}

extension UIImageView {
    func changeTintColor(_ color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

extension UIWindow {
    static var key: UIWindow? {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
