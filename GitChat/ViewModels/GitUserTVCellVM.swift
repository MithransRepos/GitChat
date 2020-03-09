//
//  GitUserTVCellVM.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation
class GitUserTVCellVM: NSObject {
    private var user: User?
    
    init(user: User?) {
        self.user = user
    }
}
extension GitUserTVCellVM: GitUserTVCellDataSource {
    func getImageUrl() -> String? {
        return user?.avatarURL
    }
    
    func getTitle() -> String? {
        guard let userId =  user?.login else { return user?.login }
        return "@\(userId)"
    }
}
