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
            GeometryReader { geometry in
                HStack(spacing: geometry.size.width * 0.15) {
                    HStack(spacing: geometry.size.width * 0.15) {
                        Text(city)
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                        Text(area)
                            .foregroundColor(.black)
                            .font(.system(size: 16))
                            .fontWeight(.regular)
                    }
                    Text(station)
                        .foregroundColor(.black)
                        .font(.system(size: 16))
                        .fontWeight(.regular)
                        .lineLimit(0)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color(.white))
                .listRowInsets(EdgeInsets())
                
            }
            .padding()
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
