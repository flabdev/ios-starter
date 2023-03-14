//
//  APIServices.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 26/02/23.
//

import Foundation

enum RequestHttpMethod: String {
    case GET
    case POST
}

struct APIService {
    
    enum HeaderFields: String {
        case host = "X-Host"
    }
    
    typealias ServiceDataResponse = (Data?, HTTPURLResponse?, NSError?) -> Void
    typealias FailureReason = (NSError?, Int?) -> Void
    
    static let shared = APIService()

    func fetchData(url: URL?, requestType: RequestHttpMethod, onCompletion: @escaping ServiceDataResponse, onFailure: @escaping FailureReason) {
        guard let url = url,
              let hostName = url.host else {
            AppLogger.shared.error("URL not found ", module: AppLogger.Module.NETWORK)
            return
        }
        let request = NSMutableURLRequest(url: url as URL ,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20.0)
        let headers = [
            HeaderFields.host.rawValue: hostName
        ]
        request.httpMethod = requestType.rawValue // For Http Method we can create a enum with all the Method types
        request.allHTTPHeaderFields = headers
        let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                onFailure(error as NSError?, nil)
                return
            }
            // Check the status code if the api is down then throw failure
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 403 {
                onFailure(error as NSError?, httpResponse.statusCode)
                return
            }
            
            guard let dataResponse = data else {
                onCompletion(nil, nil, nil)
                return
            }
            onCompletion(dataResponse, nil, nil)
        })
        dataTask.resume()
    }
}
