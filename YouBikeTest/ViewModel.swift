//
//  ViewModel.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/22.
//

import Foundation
import Combine
import CoreLocation
import RxSwift
import RxCocoa
import RxRelay
import SwiftUI

class ViewModel: ObservableObject {
    
    private let disposeBag = DisposeBag()
    
    private let alamoFireInterface = AlamoFireInterface()
    
    var searchText: String = "" {
        didSet {
            self.searchStationInfos(with: searchText)
        }
    }
    
    //MARK: -Arrays
    private var storeBikeStation: [BikeStation] = [] {
        didSet {
            setStationInfo { info in
                self.storeStation = info
            }
        }
    }
    
    private var originalStationInfos: [StationInfo] = []
    
    private var filterStationsInfos: [String] = []
    
    @Published var storeStation: [StationInfo] = [] {
        didSet {
            print("storeStation:\(storeStation)")
        }
    }
    
    @Published private var filterStationInfo: [String] = []
    
    //MARK: -Events
    private let youBikeDataSubject = PublishSubject<[StationInfo]>()
    
    private let youBikeStationDataSubject = PublishSubject<[String]>()
    
    //MARK: -Subscribe
    var youBikeDataObservable: Observable<[StationInfo]> {
            return youBikeDataSubject.asObservable()
    }
    
    private func getCityFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                return
            }
            
            if let city = placemark.subAdministrativeArea {
                print("City: \(city)")
                completion(city)
            } else {
                print("City not found.")
            }
        }
    }
    
    func getBikeStationInfoRawData() {
        alamoFireInterface.getData { stationInfo in
            self.storeBikeStation = stationInfo
        }
    }
    
    func setStationInfo(completion: @escaping ([StationInfo]) -> Void) {
        if storeBikeStation.isEmpty {
            print("storeBikeStation是空的！")
            do {
                try self.getBikeStationInfoRawData()
            } catch {
                print("Error getting bike station info: \(error)")
                completion([])
                return
            }
        } else {
            storeBikeStation.forEach { stationInfo in
                self.getCityFromCoordinates(latitude: stationInfo.lat, longitude: stationInfo.lng) { city in
                    let info = StationInfo(city: city, area: stationInfo.sarea, station: stationInfo.sna)
                    self.storeStation.append(info)
                    self.originalStationInfos.append(info)
                    self.youBikeDataSubject.onNext(self.storeStation)
                    completion(self.storeStation)
                }
            }
        }
    }
    
    //MARK: -搜尋功能
    private func searchStationInfos(with keyword: String) {
        if keyword.isEmpty {
            youBikeDataSubject.onNext(storeStation)
        } else {
            let filteredStationInfos = storeStation.filter { $0.station.contains(keyword) }
            print("filteredStationInfos:\(filteredStationInfos)")
            youBikeDataSubject.onNext(filteredStationInfos)
        }
    }
    
    //搜尋站名
    private func searchStation(with keyword: String) {
        if keyword.isEmpty {
            youBikeStationDataSubject.onNext(filterStationInfo)
        } else {
            let filteredStationInfos = storeStation.filter { $0.station.contains(keyword) }
            youBikeStationDataSubject.onNext(filteredStationInfos.map{$0.station})
        }
    }
}
