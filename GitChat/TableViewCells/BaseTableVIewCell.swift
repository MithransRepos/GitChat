//
//  BaseTableVIewCell.swift
//  GitChat
//
//  Created by MithranN on 13/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import UIKit
class BaseTableViewCell: UITableViewCell, ReuseIdentifying {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {}
    
    func setConstraints() {}
    
}


protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}


extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
