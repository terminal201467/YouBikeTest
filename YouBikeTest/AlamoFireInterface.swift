//
//  AlamoFireInterface.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/24.
//

import Foundation
import Alamofire

class AlamoFireInterface {
    // 指定 API 的 URL
    private let apiUrl = "https://tcgbusfs.blob.core.windows.net/dotapp/youbike/v2/youbike_immediate.json"

    // 發送 GET 請求
    func getData(completion: @escaping ([BikeStation]) -> Void) {
        AF.request(apiUrl, method: .get).responseJSON { response in
                switch response.result {
                case .success(let data):
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data)
                        let decoder = JSONDecoder()
                        let bikeStation = try decoder.decode([BikeStation].self, from: jsonData)
                        completion(bikeStation)
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
        }
    }
}
