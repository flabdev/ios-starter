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
                AppLogger.shared.info("urlResponce - \(String(describing: urlResponce))")
                completion(nil, .fail) // The data is nil then send fail status
                return
            }
            guard let cards = utilitiesManager.loadDecoderObject(data: responseData, type: CardModel.self) else {
                AppLogger.shared.error("Failed to parse data", module: AppLogger.Module.UTILITIES)
                completion(nil, .fail)
                return
            }
            AppLogger.shared.debug("Card data parsed successful!", module: AppLogger.Module.UTILITIES)
            completion(cards, .pass)
        } onFailure: { error, status in
            AppLogger.shared.error("staus - \(String(describing: status))")
            AppLogger.shared.error("Failed to parse data", module: AppLogger.Module.UTILITIES)
            completion(nil, .fail)
        }
    }
}
