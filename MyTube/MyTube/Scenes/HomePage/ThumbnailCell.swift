//
//  ThumbnailCell.swift
//  MyTube
//
//  Copyright (c) 2023 z-wook. All right reserved.
//

import UIKit
import SnapKit
import SwiftUI

final class ThumbnailCell: UICollectionViewCell {
    static let identifier = "ThumbnailCell"
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "photo")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var profileThumbnail: UIImageView = {
        let imageSize: CGFloat = 34
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = imageSize / 2
        view.clipsToBounds = true
        view.snp.makeConstraints {
            $0.width.height.equalTo(imageSize)
        }
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        [titleLabel, subTitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private lazy var subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        [profileThumbnail, titleStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 9
        stackView.alignment = .fill
        stackView.distribution = .fill
        [imageView, subStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        return stackView
    }()
    
    private func setLayout() {
        contentView.addSubview(mainStackView)

        mainStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    func configure(data: Thumbnails.Item) {
        let url = data.snippet.thumbnails.high.url
        let channelID = data.snippet.channelId
        Task {
            let image = await ImageCacheManager.shared.loadImage(url: url)
            imageView.image = image
        }
        Task {
            guard let profile = await YoutubeManger.shared.getProfileThumbnail(channelID: channelID),
                  let url = profile.items?.first?.snippet.thumbnails.high.url else { return }
            let image = await ImageCacheManager.shared.loadImage(url: url)
            profileThumbnail.image = image
        }
        titleLabel.text = data.snippet.title
        subTitleLabel.text = data.snippet.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
