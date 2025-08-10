//
//  BaseViewController.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 8/8/25.
//

import Foundation
import UIKit

class BaseViewController: UIViewController, BaseType {
    var backgroundImageHidden = false {
        didSet {
            bg.isHidden = backgroundImageHidden
        }
    }
    let bg = UIImageView(image: UIImage(named: "bgApp")).style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        updateUI()
        binding()
    }
    
    func initUI() {
        view.backgroundColor = .white
        view.addSubview(bg)
        bg.constraintsTo(view: self.view, position: .fullCover)
        bg.isHidden = backgroundImageHidden
    }
    
    func updateUI() {
        
    }
    
    func updateStrings() {
        
    }
    
    func binding() {
        
    }
    
    
}
