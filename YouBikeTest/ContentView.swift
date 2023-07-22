//
//  ContentView.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/21.
//

import SwiftUI

enum YouBikeColor: Int {
    case mainColor = 0, listGrayColor, listSelectedColor, searchPlaceHolderGray
    var color: UIColor {
        switch self {
        case .mainColor: return .init(hexString: "#B5CC22")!
        case .listGrayColor:
            return .init(hexString: "#F6F6F6")!
        case .listSelectedColor:
            return .init(hexString: "#677510")!
        case .searchPlaceHolderGray:
            return .init(hexString: "#AEAEAE")!
        }
    }
}

struct ContentView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("站點資訊")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color(YouBikeColor.mainColor.color))
                        .frame(alignment: .leading)
                    Spacer()
                }
                ZStack {
                    TextField("搜尋站點", text: $searchText)
                        .padding(8)
                        .padding(.horizontal, 16)
                        .background(Color(YouBikeColor.listGrayColor.color))
                        .foregroundColor(Color(YouBikeColor.searchPlaceHolderGray.color))
                        .cornerRadius(8)
                        .onTapGesture {
                            
                        }
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(YouBikeColor.searchPlaceHolderGray.color))
                            .onTapGesture {
                                // 在這裡處理右側圖片的點擊事件
                                print("Right View Tapped!")
                            }
                    }.padding(.trailing)
                }
                List {
                    Section {
                        //單數的Cell白色
                        //雙數的Cell灰色
                    } header: {
                        GeometryReader { geometry in
                            HStack(spacing: geometry.size.width * 0.15) {
                                HStack(spacing: geometry.size.width * 0.15) {
                                    Text("縣市")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                    Text("區域")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                        .fontWeight(.semibold)
                                }
                                Text("站點名稱")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                                    .fontWeight(.semibold)
                                    .padding()
                            }
                            .frame(width: geometry.size.width, height: 60)
                            .background(Color(YouBikeColor.mainColor.color))
                            .listRowInsets(EdgeInsets())
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }
                .listStyle(.grouped)
                .cornerRadius(8)
                .headerProminence(.increased)
            }
        }
        .padding(EdgeInsets.init(top: 32, leading: 32, bottom: 32, trailing: 32))
        .toolbar {
            ToolbarItem(placement:.navigationBarLeading) {
                Image("logo")
                    .renderingMode(.original)
                    .padding()
            }
            ToolbarItem {
                Button {
                    print("轉換下面的View內容")
                } label: {
                    Image("menu")
                        .renderingMode(.original)
                        .padding()
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let previewBinding = Binding<String>.constant("")
        NavigationStack {
            ContentView(searchText: previewBinding)
        }
    }
}
