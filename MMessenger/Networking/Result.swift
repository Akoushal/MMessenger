//
//  Result.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/01.
//

import Foundation

enum Result<T, U: Error> {
    case success(T)
    case failure(U)
}
