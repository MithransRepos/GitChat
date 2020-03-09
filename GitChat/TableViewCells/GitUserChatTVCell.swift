//
//  GitUserChatTVCell.swift
//  GitChat
//
//  Created by MithranN on 13/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import UIKit

struct BubbleImageType {
    static let left = "left_bubble"
    static let right = "right_bubble"
}
public protocol GitUserChatTVCellDataSource: class {
    func getText() -> String?
    func getIsSender() -> Bool
}

class GitUserChatTVCell: BaseTableViewCell {
    
    private let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private var dataSource: GitUserChatTVCellDataSource? {
        didSet {
            setData()
        }
    }
    
    override func addViews() {
        super.addViews()
        contentView.addSubview(bubbleImageView)
        bubbleImageView.addSubview(label)
    }
    
    override func setConstraints() {
        super.setConstraints()
        bubbleImageView.set(.sameTopBottom(contentView, Padding.p2), .sameLeadingTrailing(contentView))
        label.set(.sameTopBottom(bubbleImageView, Padding.p10), .sameLeadingTrailing(bubbleImageView, Padding.p10*2))
    }
    
    func setDataSource(_ dataSource: GitUserChatTVCellDataSource) {
        self.dataSource = dataSource
    }
    
    private func setData() {
        label.text = dataSource?.getText()
        // setting the correct bubble image
        let shouldShowRightBubble = dataSource?.getIsSender() ?? false
        let bubbleImage = (UIImage.init(named: shouldShowRightBubble ? BubbleImageType.right : BubbleImageType.left))?
            .resizableImage(withCapInsets: UIEdgeInsets(top: (Padding.p8*2), left: Padding.p20 + 2, bottom: Padding.p8*2, right: Padding.p20 + 2))
        bubbleImageView.image = bubbleImage
        
        // setting the left right margin
        let margin = getMargin(for: dataSource?.getText(), font: label.font)
        bubbleImageView.get(.leading)?.constant = shouldShowRightBubble ?  margin : Padding.p12
        bubbleImageView.get(.trailing)?.constant = shouldShowRightBubble ? -Padding.p12 : -margin
        label.textAlignment =  shouldShowRightBubble ? .right : .left
    }
    
    private func getMargin(for text: String?, font: UIFont) -> CGFloat {
        guard let text = text else {
            return 0
        }
        let textSize: CGSize = text.sizeOfString(usingFont: font)
        let estimatedMargin = UIScreenHelper.screenWidth - UIScreenHelper.twentyPercentOfScreenWidth - textSize.width + (Padding.p12*Padding.p2)
        let margin = estimatedMargin > 0 ? estimatedMargin : UIScreenHelper.twentyPercentOfScreenWidth
        return margin
    }
    
    override func prepareForReuse() {
        label.text = nil
        bubbleImageView.image = nil
    }
    
}
