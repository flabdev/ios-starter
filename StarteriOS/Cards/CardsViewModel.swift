//
//  CardsViewModel.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 27/02/23.
//

import Foundation

protocol CardsViewModelDelegate {
    func failStatus()
    func refreshData()
}

class CardsViewModel: NSObject {
    var apiManager = APIManager.shared
    var bindViewModelToController : (() -> Void) = {}
    var delegate: CardsViewModelDelegate?
    
    private(set) var cardModel: CardModel? {
        didSet {
            self.bindViewModelToController()
        }
    }
    
    override init() {
        super.init()
        self.fetchData()
    }
    
    // Fetch Data from server and update the
    func fetchData() {
        apiManager.getCards(completion: { response, status in
            switch status {
                case .pass: self.cardModel = response
                case .fail: self.delegate?.failStatus()
            }
        })
    }
}
