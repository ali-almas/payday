//
//  JSON.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import Foundation

final class JSON {
    func encode<T: Encodable>(input: T) -> Data {
        do {
            let data = try JSONEncoder().encode(input)
            return data
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
