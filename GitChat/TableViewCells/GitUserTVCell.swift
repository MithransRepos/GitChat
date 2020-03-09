//
//  GitUserTVCell.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import UIKit

public protocol GitUserTVCellDataSource: class {
    func getImageUrl() -> String?
    func getTitle() -> String?
}


class GitUserTVCell: BaseTableViewCell {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private var dataSource: GitUserTVCellDataSource? {
        didSet {
            setData()
        }
    }
    
    func setDataSource(_ dataSource: GitUserTVCellVM) {
        self.dataSource = dataSource
    }
    
    private func setData() {
        self.label.text = dataSource?.getTitle()
        self.avatarImageView.setImage(fromURL: dataSource?.getImageUrl())
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
    }
    
    override func setConstraints() {
        super.setConstraints()
        avatarImageView.set(.leading(contentView, Padding.p12), .top(contentView, Padding.p12, .greaterThanOrEqual),
                            .bottom(contentView, Padding.p12,.greaterThanOrEqual), .size(Padding.p20 * 2, Padding.p20 * 2))
        label.set(.after(avatarImageView, Padding.p12), .centerY(contentView))
    }
    
    override func prepareForReuse() {
        label.text = nil
        avatarImageView.image = nil
    }
    
}
