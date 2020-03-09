//
//  UserDataManager.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation
class UserDataManager {
    private let router = Router<UserApi>()

    func getUsers(completion: @escaping (Result<[User]?, APIError>) -> Void) {
        router.fetch(.getUsers, decode: { json -> [User]? in
            json as? [User]
        }, completion: completion)
    }

}
