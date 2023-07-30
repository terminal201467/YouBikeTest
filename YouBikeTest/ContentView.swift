//
//  ContentView.swift
//  YouBikeTest
//
//  Created by Jhen Mu on 2023/7/21.
//

import SwiftUI
import RxSwift
import RxRelay

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
    
    private let disposeBag = DisposeBag()
    
    @ObservedObject var viewModel = ViewModel()
    
    @State private var isMenuOn: Bool = false
    
    @State private var selectedCell: String? = nil
    
    @State private var selectedIndex: Int? = nil
    
    private var menu: [String] = ["使用說明", "收費方式","站點資訊","最新消息","活動專區"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                            TextField("搜尋站點", text: $viewModel.searchText)
                                .padding(8)
                                .padding(.horizontal, 16)
                                .background(Color(YouBikeColor.listGrayColor.color))
                                .foregroundColor(Color(YouBikeColor.searchPlaceHolderGray.color))
                                .cornerRadius(8)
                            HStack {
                                Spacer()
                                Button {
                                    self.viewModel.searchBehavior.onNext(())
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Color(YouBikeColor.searchPlaceHolderGray.color))
                                }
                            }.padding(.trailing)
                        }
                        ZStack { GeometryReader { geography in
                            List {
                                Section(){
                                    Spacer()
                                    ForEach(viewModel.storeStation.indices, id: \.self) { index in
                                        let info = $viewModel.storeStation[index]
                                        ListContentView(city: info.city, area: info.area, station: info.station)
                                            .listRowBackground(index % 2 == 0 ? Color.white : Color(YouBikeColor.listGrayColor.color))
                                    }
                                } header: {
                                    GeometryReader { geometry in
                                        HStack(spacing: geometry.size.width * 0.15) {
                                            Text("縣市")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                                .padding()
                                            Text("區域")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                                .padding()
                                            Text("站點名稱")
                                                .foregroundColor(.white)
                                                .font(.system(size: 16))
                                                .fontWeight(.semibold)
                                                .padding()
                                        }
                                        .frame(width: geometry.size.width, height: 60)
                                        .background(Color(YouBikeColor.mainColor.color))
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .headerProminence(.increased)
                            }
                            .listStyle(.grouped)
                            .cornerRadius(8)
                            .backgroundStyle(Color.white)
                            .headerProminence(.increased)
                            .onAppear {
                                viewModel.getBikeStationInfoRawData()
                            }
                            List{
                                ForEach($viewModel.storefilterStationInfo.indices, id: \.self) { index in
                                    let info = viewModel.storefilterStationInfo[index]
                                    HStack {
                                        Text("\(info)")
                                            .padding(.leading)
                                            .foregroundColor(selectedIndex == index ? Color(YouBikeColor.mainColor.color) : .black)
                                        Spacer()
                                    }
                                    .listRowBackground(Color(YouBikeColor.listGrayColor.color))
                                    .onTapGesture {
                                        selectedIndex = index
                                        viewModel.searchText = info
                                        self.viewModel.searchBehavior.onNext(())
                                    }
                                }
                            }
                            .scrollContentBackground(.hidden)
                            .scrollIndicators(.hidden)
                            .listStyle(.plain)
                            .cornerRadius(8)
                            .backgroundStyle(Color.clear)
                            .opacity(viewModel.isSearchingModeRelay.value ? 1.0 : 0.0)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listSectionSeparator(.hidden)
                            .listRowInsets(EdgeInsets())
                            .frame(height: geometry.size.height * 0.5)
                            }
                        }
                    }
                }
                .padding(EdgeInsets.init(top: 32, leading: 32, bottom: 32, trailing: 32))
                NavigationStack {
                    Spacer()
                    List {
                        Section {
                            ForEach(menu, id: \.self) { text in
                                Text(text)
                                    .listRowInsets(EdgeInsets(top: 5, leading: 20, bottom: 5, trailing: 20))
                                    .foregroundColor(
                                        selectedCell == text ? Color(YouBikeColor.listSelectedColor.color) : Color(.white)
                                    )
                                    .onTapGesture {
                                        selectedCell = text
                                    }
                            }
                            .padding(.init(top: 16, leading: 16, bottom: 8, trailing: 16))
                        } footer: {
                            Spacer()
                            Spacer()
                            HStack {
                                Button(action: {
                                    print("登入Action")
                                }) {
                                    Text("登入")
                                        .foregroundColor(Color(YouBikeColor.mainColor.color))
                                        .padding(.init(top: 16, leading: 16, bottom: 16, trailing: 16))
                                        .background(.white)
                                        .cornerRadius(100)
                                }
                                .frame(width: 80, height: 40)
                                .padding(.init(top: 8, leading: 32, bottom: 8, trailing: 16))
                                Spacer()
                                Spacer()
                            }
                            .opacity(isMenuOn ? 1.0 : 0.0)
                            .background(Color(YouBikeColor.mainColor.color))
                            Spacer()
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color(YouBikeColor.mainColor.color))
                        .frame(height: 80)
                    }
                    .listStyle(.plain)
                    .opacity(isMenuOn ? 1.0 : 0.0)
                }
            }
            .toolbar {
                ToolbarItem(placement:.navigationBarLeading) {
                    Image("logo")
                        .renderingMode(.original)
                        .padding()
                }
                ToolbarItem {
                    Button {
                        self.isMenuOn.toggle()
                        if isMenuOn {
                            selectedCell = nil
                        }
                    } label: {
                        Image(isMenuOn ? "close" : "menu")
                            .renderingMode(.original)
                            .padding()
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}
