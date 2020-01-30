//
//  ErrorResult.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/27/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    case custom(errorDescription: String?) // Custom error used in Web3Helper class
}

extension ErrorResult: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .custom(let errorDescription): return errorDescription
        }
    }
}

extension ErrorResult: Equatable {
    static func == (lhs: ErrorResult, rhs: ErrorResult) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
