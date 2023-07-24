//
//  BikeStation.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/22.
//

import Foundation

//CodableStruct
struct BikeStation: Codable {
    let sno: String
    let sna: String
    let tot: Int
    let sbi: Int
    let sarea: String
    let mday: String
    let lat: Double
    let lng: Double
    let ar: String
    let sareaen: String
    let snaen: String
    let aren: String
    let bemp: Int
    let act: String
    let srcUpdateTime: String
    let updateTime: String
    let infoTime: String
    let infoDate: String
}

//FeedingData
struct StationInfo: Hashable {
    var city: String
    var area: String
    var station: String
}
