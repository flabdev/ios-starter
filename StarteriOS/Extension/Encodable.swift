//
//  Encodable.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 24/02/23.
//
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any?] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any?] else {
            throw NSError()
        }
        return dictionary
    }
    
    func asNSDictionary() throws -> NSDictionary {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary else {
            throw NSError()
        }
        return dictionary
    }
}
