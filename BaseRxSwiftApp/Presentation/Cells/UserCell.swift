//
//  UserCell.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 9/8/25.
//

import Foundation
import UIKit

final class UserCell: BaseTableViewCell {
    let imgView = UIImageView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }
    
    let labelName = UILabel().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    override func initUI() {
        super.initUI()
        contentView.addSubview(imgView)
        contentView.addSubview(labelName)
        
        imgView.size(50)
        imgView.constraintsTo(view: contentView, position: .top, constant: 8, relationContraint: .greaterOrEqual)
        imgView.constraintsTo(view: contentView, position: .left, constant: 8, relationContraint: .equal)
        imgView.constraintsTo(view: contentView, position: .bottom, constant: -8, relationContraint: .lessOrEqual)
        imgView.constraintsTo(view: contentView, position: .centerY)

        labelName.constraintsTo(view: imgView, position: .leftToRight, constant: 8)
        labelName.constraintsTo(view: contentView, position: .top, constant: 8)
        labelName.constraintsTo(view: contentView, position: .right, constant: 8, relationContraint: .greaterOrEqual)
    }
    
    func configCell(user: User) {
            labelName.text = user.name ?? user.login // adjust to your model
            if let urlString = user.avatarURL, let url = URL(string: urlString) {
                loadImage(from: url)
            } else {
                imgView.image = UIImage(systemName: "person.crop.circle")
            }
        }
    
    private func loadImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }.resume()
        }
}
