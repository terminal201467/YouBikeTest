//
//  SearchListContent.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/28.
//

import SwiftUI

struct SearchListContent: View {
    
    @Binding var placeName: String
    
    var body: some View {
        HStack {
            Text("\(placeName)")
                .padding(.leading)
                .foregroundColor(.black)
            Spacer()
        }
    }
}

struct SearchListContent_Previews: PreviewProvider {
        
    @State static var station: String = "Daan"
            
    static var previews: some View {
        SearchListContent(placeName: $station)
    }
}
