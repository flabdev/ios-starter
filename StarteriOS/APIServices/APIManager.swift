//
//  APIManager.swift
//  Trading
//
//  Created by Nagesh Kumar Mishra on 22/12/22.
//

import Foundation

enum APIStatus: Error {
    case pass
    case fail
}

struct APIManager {
    
    // Single instance
    static let shared = APIManager()
    let utilitiesManager = UtilitiesManager()

    // MARK: Get Cards data
    func getCards(completion: @escaping ((_ responce: CardModel?, _ success: APIStatus) -> Void)) {
        let endpoint = Endpoint.getCards
        APIService.shared.fetchData(url: endpoint.url, requestType: .GET) { data, urlResponce, error in
            guard let responseData = data else {
                Logger.shared.info("urlResponce - \(String(describing: urlResponce))")
                completion(nil, .fail) // The data is nil then send fail status
                return
            }
            guard let cards = utilitiesManager.loadDecoderObject(data: responseData, type: CardModel.self) else {
                Logger.shared.error("Failed to parse data", module: Logger.Module.UTILITIES)
                completion(nil, .fail)
                return
            }
            Logger.shared.debug("Card data parsed successful!", module: Logger.Module.UTILITIES)
            completion(cards, .pass)
        } onFailure: { error, status in
            Logger.shared.error("staus - \(String(describing: status))")
            Logger.shared.error("Failed to parse data", module: Logger.Module.UTILITIES)
            completion(nil, .fail)
        }
    }
}
