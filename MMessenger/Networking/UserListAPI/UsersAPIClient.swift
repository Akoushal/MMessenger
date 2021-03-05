//
//  UsersAPIClient.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/01.
//

import Foundation

final class UsersAPIClient {
    let session: URLSession
    let baseUrl = "https://api.github.com/"
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchUsers(with request: UsersAPIRequest, since: Int, completion: @escaping (Result<[User], DataResponseError>) -> Void) {
        // 1
        guard let baseUrl = URL(string: baseUrl) else { return }
        let urlRequest = URLRequest(url: baseUrl.appendingPathComponent(request.path))
        // 2
        let parameters = ["since": "\(since)"].merging(request.parameters, uniquingKeysWith: +)
        // 3
        let encodedURLRequest = urlRequest.encode(with: parameters)
        
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            // 4
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessStatusCode,
                let data = data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            // 5
            guard let decodedResponse = try? JSONDecoder().decode([User].self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            // 6
            completion(Result.success(decodedResponse))
        }).resume()
    }
}

