//
//  GitUserDmThreadVM.swift
//  GitChat
//
//  Created by MithranN on 13/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation

public protocol GitUserDmThreadVMDelegate: class {
    func reloadView()
}

class GitUserDmThreadVM: NSObject {
    private weak var delegate: GitUserDmThreadVMDelegate?
    private var messages: [Message] = []
    private var userId: String?
    
    init(delegate: GitUserDmThreadVMDelegate, userId: String?) {
        super.init()
        self.delegate = delegate
        self.userId = userId
        getDMThreadIfAvailable()
    }
    
    // storing messages in user defaults
    private func storeDMThread() {
        guard let userId = userId else { return }
        UserDefaults.standard.set(try? PropertyListEncoder().encode(messages), forKey: userId)
    }
    
    // getting messages in user defaults
    private func getDMThreadIfAvailable() {
        guard let userId = userId,
            let threadData =  UserDefaults.standard.value(forKey: userId) as? Data,
            let messages = try? PropertyListDecoder().decode([Message].self, from: threadData),
            messages.count > 0 else { return }
        self.messages = messages
        delegate?.reloadView()
    }
    
    
}

// MARK: GitUserDmThreadVCDataSource functions
extension GitUserDmThreadVM: GitUserDmThreadVCDataSource {
    func viewWillDisappear() {
        storeDMThread()
    }
    
    func getNumberOfMessages() -> Int {
        return messages.count
    }
    
    func getMessage(at index: Int) -> Message? {
        return messages[safeIndex: index]
    }
    // local implentation of message reply
    func sendMessage(text: String?) {
        guard let text = text?.trimmingCharacters(in: .whitespaces), text.count > 0 else {
            return
        }
        messages.append(Message(text: text, isSent: true))
        messages.append(Message(text: "\(text) \(text)", isSent: false))
        delegate?.reloadView()
    }
    
    
}
