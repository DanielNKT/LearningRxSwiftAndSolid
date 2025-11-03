//
//  UserCell.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 9/8/25.
//

import Foundation
import UIKit

final class UserCell: BaseTableViewCell {
    
    let userView = UserView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }

    override func initUI() {
        super.initUI()
        backgroundColor = .clear
        contentView.addSubview(userView)
        
        userView.constraintsTo(view: contentView, position: .top, constant: 4)
        userView.constraintsTo(view: contentView, position: .bottom, constant: -4)
        userView.constraintsTo(view: contentView, position: .left, constant: 8)
        userView.constraintsTo(view: contentView, position: .right, constant: -8)

    }

    func configCell(user: User) {
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

final class UserView: BaseView {
    private let shadowContainer = UIView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addShadow(color: .black, opacity: 0.3, offset: CGSize(width: -3, height: 3), radius: 3)
        $0.backgroundColor = .clear
    }

    private let borderView = UIView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.circleView(radius: .number(8))
        $0.backgroundColor = .white
    }

    let imgView = UIImageView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
    }

    let labelName = UILabel().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
    }
    
    let lineView = UIView().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .systemGray5
    }
    
    let labelHtml = UILabel().style {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .blue
        $0.numberOfLines = 0
    }

    override func initUI() {
        super.initUI()
        backgroundColor = .clear

        self.addSubview(shadowContainer)
        shadowContainer.addSubview(borderView)
        borderView.addSubviews(
            imgView,
            labelName,
            lineView,
            labelHtml
        )

        // Shadow container constraints
        shadowContainer.constraintsTo(view: self, position: .full)

        // Border view fills shadow container
        borderView.constraintsTo(view: shadowContainer, position: .full, constant: 2)

        imgView.size(80)
        imgView.constraintsTo(view: borderView, position: .top, constant: 8, relationContraint: .greaterOrEqual)
        imgView.constraintsTo(view: borderView, position: .left, constant: 8, relationContraint: .equal)
        imgView.constraintsTo(view: borderView, position: .bottom, constant: -8, relationContraint: .lessOrEqual)
        imgView.constraintsTo(view: borderView, position: .centerY)

        labelName.constraintsTo(view: imgView, position: .leftToRight, constant: 8)
        labelName.constraintsTo(view: borderView, position: .top, constant: 8)
        labelName.constraintsTo(view: borderView, position: .right, constant: -8, relationContraint: .greaterOrEqual)
        
        lineView.constraintsTo(view: imgView, position: .leftToRight, constant: 4)
        lineView.constraintsTo(view: borderView, position: .right, constant: -4)
        lineView.constraintsTo(view: labelName, position: .topToBottom, constant: 4)
        lineView.height(1)
        
        labelHtml.constraintsTo(view: imgView, position: .leftToRight, constant: 8)
        labelHtml.constraintsTo(view: borderView, position: .right, constant: -8, relationContraint: .greaterOrEqual)
        labelHtml.constraintsTo(view: lineView, position: .topToBottom, constant: 4)
        labelHtml.constraintsTo(view: borderView, position: .bottom, constant: 4, relationContraint: .lessOrEqual)
    }
}

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private let session = URLSession(configuration: .default)

    func cachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url as NSURL)
    }

    @discardableResult
    func load(_ url: URL, completion: @escaping (UIImage?) -> Void) -> URLSessionDataTask {
        if let img = cachedImage(for: url) {
            DispatchQueue.main.async { completion(img) }
            // Return a dummy task that’s already “completed”
            return URLSessionDataTask()
        }
        let task = session.dataTask(with: url) { [weak self] data, _, _ in
            var image: UIImage?
            if let data = data, let img = UIImage(data: data) {
                image = img
                self?.cache.setObject(img, forKey: url as NSURL)
            }
            DispatchQueue.main.async { completion(image) }
        }
        task.resume()
        return task
    }
}
