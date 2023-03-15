//
//  UtilitiesManager.swift
//  StarteriOS
//
//  Created by Nagesh Kumar Mishra on 20/02/23.
//

import Foundation

struct UtilitiesManager {
    
    func loadJson(filename fileName: String) -> Data? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return data
            } catch {
                AppLogger.shared.error("JSON load failed with error: \(error)")
            }
        }
        return nil
    }
    
    func loadDecoderObject<T: Decodable>(data: Data, type: T.Type) -> T? {
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            AppLogger.shared.error("Failed to load Decoder object with error: \(error)")
        }
        return nil
    }
}
