//
//  CardModel.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 27/02/23.
//

import Foundation

struct CardModel: Codable {
    let status: Int?
    let cards: [Cards]?
}

struct Cards: Codable {
    let cardNumber: String?
    let userName: String?
    let expiryDate: String?
    let cardDetails: String?
    let cardType: String?
    var isItemSelected: Bool?
    
}
