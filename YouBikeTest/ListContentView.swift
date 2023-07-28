//
//  ListContentView.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/22.
//

import SwiftUI

struct ListContentView: View {
    
    @Binding var city: String
    @Binding var area: String
    @Binding var station: String
    
    var body: some View {
        VStack {
            HStack {
                Text("\(city)")
                    .padding()
                Text("\(area)")
                    .padding()
                Text("\(station)")
                    .padding()
            }
        }
    }
}

struct ListContentView_Previews: PreviewProvider {
    
    @State static var city: String = "Taipei"
    @State static var area: String = "Daan"
    @State static var station: String = "Station 1"
    
    static var previews: some View {
        List {
            ListContentView(city: $city, area: $area, station: $station)
        }
    }
}
