//
//  GitUserChatTVCellVM.swift
//  GitChat
//
//  Created by MithranN on 13/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation
class GitUserChatTVCellVM: NSObject {
    private var message: Message?
    
    init(message: Message?) {
        self.message = message
    }
}

extension GitUserChatTVCellVM: GitUserChatTVCellDataSource {
    func getText() -> String? {
        return message?.text
    }
    
    func getIsSender() -> Bool {
        return message?.isSent ?? false
    }
}
