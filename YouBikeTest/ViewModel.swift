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

class ViewModel: ObservableObject {
    
    private let disposeBag = DisposeBag()
    
    private let alamoFireInterface = AlamoFireInterface()
    
    var searchText: String = ""
    
    //MARK: -Arrays
    private var storeBikeStation: [BikeStation] = []
    
    var storeStation: [StationInfo] = []
    
    //MARK: -Events
    private let youBikeDataSubject = PublishSubject<[StationInfo]>()
    
    //inputText filter事件流
    
    
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
            
            if let city = placemark.locality {
                print("City: \(city)")
                completion(city)
            } else {
                print("City not found.")
            }
        }
    }
    
    func getBikeStationInfoRawData() {
        alamoFireInterface.getData { stationInfo in
            print("stationInfo:\(stationInfo)")
            self.storeBikeStation = stationInfo
        }
    }
    
    private func setStationInfo(completion: @escaping ([StationInfo]) -> Void) {
        if storeBikeStation.isEmpty {
            print("storeBikeStation是空的！")
            self.getBikeStationInfoRawData()
        } else {
            storeBikeStation.map { stationInfo in
                self.getCityFromCoordinates(latitude: stationInfo.lat, longitude: stationInfo.lng) { city in
                    let info = StationInfo(city: city, area: stationInfo.sarea, station: stationInfo.sna)
                    self.storeStation.append(info)
                    print("storeStation的內容：\(self.storeStation)")
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
