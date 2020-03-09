//
//  UserEndPoint.swift
//  GitChat
//
//  Created by MithranN on 11/12/19.
//  Copyright © 2019 MithranN. All rights reserved.
//

import Foundation
public enum UserApi {
    case getUsers
}

extension UserApi: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: NetworkConstants.BaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getUsers:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
