//
//  SettingsViewController.swift
//  BaseRxSwiftApp
//
//  Created by Bé Gạo on 13/8/25.
//
import UIKit

enum ProfileContentType {
    case grid
    case reels
    case tagged
}

class SettingsViewController: BaseViewController, BindableType {
    var viewModel: SettingsViewModel!
    
    private var collectionView: UICollectionView!
    private var selectedContent: ProfileContentType = .grid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Register cells + header
        collectionView.register(ProfileHeaderCell.self, forCellWithReuseIdentifier: ProfileHeaderCell.id)
        collectionView.register(PostCell.self, forCellWithReuseIdentifier: PostCell.id)
        collectionView.register(
            SegmentHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SegmentHeaderView.id
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            
            switch sectionIndex {
            case 0: // Header
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(180))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitems: [item])
                return NSCollectionLayoutSection(group: group)
                
            case 1: // Sticky Segment
                // Dummy item (won’t be visible)
                   let dummySize = NSCollectionLayoutSize(
                       widthDimension: .fractionalWidth(1.0),
                       heightDimension: .absolute(0.1)
                   )
                   let dummyItem = NSCollectionLayoutItem(layoutSize: dummySize)
                   let group = NSCollectionLayoutGroup.horizontal(layoutSize: dummySize, subitems: [dummyItem])
                   let section = NSCollectionLayoutSection(group: group)

                   // Sticky header
                   let headerSize = NSCollectionLayoutSize(
                       widthDimension: .fractionalWidth(1.0),
                       heightDimension: .absolute(50)
                   )
                   let header = NSCollectionLayoutBoundarySupplementaryItem(
                       layoutSize: headerSize,
                       elementKind: UICollectionView.elementKindSectionHeader,
                       alignment: .top
                   )
                   header.pinToVisibleBounds = true   // 👈 makes it sticky
                   section.boundarySupplementaryItems = [header]
                   return section
                
            case 2: // Dynamic posts/reels/tagged
                switch self.selectedContent {
                case .grid:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7),
                                                          heightDimension: .fractionalWidth(1/7))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .fractionalWidth(1/7)),
                        subitems: [item, item, item])
                    return NSCollectionLayoutSection(group: group)
                    
                case .reels:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                          heightDimension: .absolute(200))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                    return NSCollectionLayoutSection(group: group)
                    
                case .tagged:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                          heightDimension: .absolute(180))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                           heightDimension: .absolute(180)),
                        subitems: [item, item])
                    return NSCollectionLayoutSection(group: group)
                }
                
            default:
                return nil
            }
        }
    }
    
    // MARK: - Segment Change
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: selectedContent = .grid
        case 1: selectedContent = .reels
        case 2: selectedContent = .tagged
        default: break
        }
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.reloadSections(IndexSet(integer: 2))
    }
}

// MARK: - DataSource
extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 0 // no items, header only
        case 2:
            switch selectedContent {
            case .grid: return 150
            case .reels: return 10
            case .tagged: return 6
            }
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(withReuseIdentifier: ProfileHeaderCell.id, for: indexPath)
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.id, for: indexPath) as! PostCell
            switch selectedContent {
            case .grid: cell.configure(color: .systemBlue, text: "📷 \(indexPath.item)", indexPath: indexPath)
            case .reels: cell.configure(color: .systemRed, text: "🎬 Reel \(indexPath.item)", indexPath: indexPath)
            case .tagged: cell.configure(color: .systemGreen, text: "🏷 Tagged \(indexPath.item)", indexPath: indexPath)
            }
            return cell
        default:
            fatalError()
        }
    }
    
    // Sticky header for segment
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1 {
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: SegmentHeaderView.id,
                    for: indexPath
                ) as! SegmentHeaderView
                view.segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
                return view
            }
            return UICollectionReusableView()
    }
}

//
// MARK: - Cells
//

class ProfileHeaderCell: UICollectionViewCell {
    static let id = "header"
    
    private let imageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        iv.tintColor = .systemGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Appleseed"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer | Swift | UIKit & SwiftUI"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [nameLabel, bioLabel, followButton])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imageView)
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            stack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 16)
        ])
        
        
    }
    required init?(coder: NSCoder) { fatalError() }
}

class SegmentHeaderView: UICollectionReusableView {
    static let id = "segmentHeader"
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Grid", "Reels", "Tagged"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

class PostCell: UICollectionViewCell {
    static let id = "post"
    
    private let label = UILabel()
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        imageView.constraintsTo(view: contentView)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(color: UIColor, text: String, indexPath: IndexPath) {
        contentView.backgroundColor = color
        label.text = text
        label.textColor = .white
        loadRandomImage(indexPath: indexPath)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func loadRandomImage(indexPath: IndexPath) {
        // if cached, use it
            if let cachedImage = ImageCache.shared.get(for: indexPath) {
                self.imageView.image = cachedImage
                return
            }

            // otherwise download
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    ImageCache.shared.set(image, for: indexPath) // cache it
                    self.imageView.image = image
                }
            }.resume()
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

final class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    // Save
    func set(_ image: UIImage, for indexPath: IndexPath) {
        cache.setObject(image, forKey: key(for: indexPath))
    }

    // Load
    func get(for indexPath: IndexPath) -> UIImage? {
        return cache.object(forKey: key(for: indexPath))
    }

    // Clear all
    func clear() {
        cache.removeAllObjects()
    }

    // Helper
    private func key(for indexPath: IndexPath) -> NSString {
        return "\(indexPath.section)-\(indexPath.item)" as NSString
    }
}
