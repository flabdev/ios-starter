//
//  UtilitiesManager.swift
//  Trading
//
//  Created by Nagesh Kumar Mishra on 22/12/22.
//

import Foundation

struct UtilitiesManager {
    
    func loadJson(filename fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                print("error:\(error)")
                
            }
        }
        return nil
    }
    
    func loadDecoderObject<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            print("error: - \(error)")
        }
        return nil
    }
    

}
