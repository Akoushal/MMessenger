//
//  UsersAPIRequest.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/01.
//

import Foundation

struct UsersAPIRequest {
    var path: String {
        return "users"
    }
    
    let parameters: Parameters
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension UsersAPIRequest {
    static func parameterizedRequest() -> UsersAPIRequest {
        let defaultParameters = ["accept": "application/vnd.github.v3+json", "per_page": "\(100)"]
        return UsersAPIRequest(parameters: defaultParameters)
    }
}
