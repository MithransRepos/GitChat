//
//  Message.swift
//  GitChat
//
//  Created by MithranN on 13/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation
public struct Message: Codable {
    let text: String?
    let isSent: Bool
}

