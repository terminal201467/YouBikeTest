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
    
    var searchText: String = ""
    
    //MARK: -Arrays
    private var storeBikeStation: [BikeStation] = [] {
        didSet {
            setStationInfo { info in
                self.storeStation = info
            }
        }
    }
    
    @Published var storeStation: [StationInfo] = [] {
        didSet {
            print("storeStation:\(storeStation)")
        }
    }
    
    //MARK: -Events
    private let youBikeDataSubject = PublishSubject<[StationInfo]>()
    
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
                    self.youBikeDataSubject.onNext(self.storeStation)
                    completion(self.storeStation)
                }
            }
        }
    }

    
    var youBikeDataFuture: Future<[StationInfo], Never> {
        Future { promise in
            self.youBikeDataSubject
                .subscribe(onNext: { stationInfos in
                    promise(.success(stationInfos))
                })
                .disposed(by: self.disposeBag)
        }
    }
}
