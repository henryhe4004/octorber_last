//
//  ImageUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI
import LeanCloud

final class Image1: ObservableObject {
    @Published  var img: [String]
    @Published var date: [Int]

    init() {
        img = ["school","old","littleYou","grandma"]
        date = [25,24,23,21]
    }
    func addImg(imgplus : String) {
        img.append(imgplus)
    }

    func addImg(imgplus: Int) {
        date.append(imgplus)
    }
}

final class Album1: ObservableObject {
    @Published var persona : [String]
    @Published var imga : [String]
    @Published var numa : [Int]
    @Published  var Album : [String]
    @Published var numa1: [Int]
    @Published var imga1 : [String]
    init() {
        persona = ["妈妈","小游","智妍"]
        numa = [1,8,155]
        Album = ["大学生活","老照片","我的小时候","高中回忆"]
        numa1 = [15,20,30,15]
        imga = ["ma","littleYou","me"]
        imga1 = ["university","old","me","school"]
    }
  
}


struct ImageUIView: View {
    @State var selectWhich : [String] = ["照片","相册","回忆"]
    @State private var indexSelected : Int = 1
    @ObservedObject var imagepick : Imagepicker = Imagepicker()
    //默认为照片
    @State var detailImage : String = " "
//    @ObservedObject var imageOfAlbum : ImageOfAlbum = imageOfAlbum()
    @State var detailAlbum : String = " "
    @State var detailText : String = " "
    @State var isSelected : Bool = false
    @State var isSelected1 : Bool = false
    @State var SelectWho : Int = 1
    @State private var headerRefreshing: Bool = false
    @State private var footerRefreshing: Bool = false
    @State private var listState = ListState()
    @ObservedObject var imageTogether : ImageTogether = ImageTogether()
    @ObservedObject var album:Album
    var body: some View {
        
        NavigationView {
            VStack{
//                HStack {
//                    Image("Iconly-Bulk-Setting")
//                            .resizable()
//                            .frame(width:23,
//                                   height:23,
//                                   alignment:.center)
//                        Spacer()
//                        Text("Family album")
//                            .foregroundColor(Color("AccentColor"))
//                            .font(.system(size: 18))
//                        Spacer()
//
//
//                    }.padding()
             ZStack{
               ScrollView(.vertical, showsIndicators: false){
                      Divider()
                   VStack{
//                      HStack{
//                         Button(action: {
//                               indexSelected=1
//                        }){
//                         HStack {
//                              Image(indexSelected == 1 ? "c1" : "gray camera" )
//                              Text("照片")
//                                  .frame(width: 40, height: 20, alignment: .center)
//                                  .cornerRadius(32)
//                                  .foregroundColor( grayColor )
//                        }
//                      }
//                        .frame(width: 100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center)
//                        .animation(.easeInOut)
//                        .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
//                        .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
//                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 10))
//                       Button(action: {
//                           indexSelected=2
//                       }){
//                          HStack {
//                             Image(indexSelected == 2 ? "orange photo" : "c2" )
//                              Text("相册")
//                                 .frame(width: 40, height: 20, alignment: .center)
//                                 .cornerRadius(32)
//                                 .foregroundColor( grayColor )
//                          }
//                        }
//                        .frame(width: 100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center)
//                        .animation(.easeInOut)
//                        .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
//                        .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
//                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
//                       Button(action: {
//                          indexSelected = 3
//                       }){
//                         HStack {
//                               Image(indexSelected == 3 ? "orange video" : "c4" )
//                               Text("回忆")
//                                .frame(width: 40, height: 20, alignment: .center)
//                                .cornerRadius(32)
//                                .foregroundColor( grayColor )
//                        }
//                      }
//                      .frame(width: 100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center)
//                      .animation(.easeInOut)
//                      .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
//                      .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
//                      .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 10))
//                   }.frame(width:360)
                   if(indexSelected == 1){
//
//                        albumUIView(album: album, detailImage: $detailImage, detailText: $detailText,isSelected: $isSelected,
//                                    selectWho:$SelectWho
//                                    ).onAppear(perform: {
////                            album.updateDateNeed()
//                        })
//                            }
                        PullToRefreshView(header: RefreshDefaultHeader(), footer: RefreshDefaultFooter()) {
                            albumUIView(album: album, detailImage: $detailImage, detailText: $detailText,isSelected: $isSelected,selectWho:$SelectWho).contentShape(Rectangle())
                        }.environmentObject(listState)
                    }
//                    if(indexSelected == 2){
////                        ZStack{
////                            ScrollView(.vertical, showsIndicators: false){
//                                photosUIView(detailAlbum: $detailAlbum, detailText: $detailText,isSelected1: $isSelected1)
////                            }
//
////                        }
//                    }
//                    if(indexSelected == 3){
//                        //                    Text("123").font(.system(size: 100))
//                        ScrollView(.vertical, showsIndicators: false){
//                            VideoUIView()
//                        }
//                    }
                   }
                }
                    if(isSelected){
                        ZStack{
                            Rectangle().fill(Color.gray).opacity(0.5)
                            VStack{
                                FlippingView(isSelected: $isSelected, album: album,selectWho: $SelectWho)
                                }.contentShape(Rectangle())
                            }
                        }
//                    if(isSelected1){
//                        ZStack{
//                            Rectangle().fill(Color.gray).opacity(0.5)
//                            VStack{
//                            DetailAlbumUIView(detailAlbum: $detailAlbum, detailText: $detailText, isSelected1: $isSelected1)
//                                 }
//                            }
//                        }
                  }
              }.addPullToRefresh(isHeaderRefreshing: $headerRefreshing, onHeaderRefresh: reloadData,
                                 isFooterRefreshing: $footerRefreshing, onFooterRefresh: loadMoreData)
                .navigationBarTitle("family album",displayMode: .inline)
                .navigationBarItems(trailing:  NavigationLink(
                    destination: IssueUIView(imagepick:imagepick).onAppear(perform: {
                            imagepick.img = []
                        }))
                    {
                        Image("Iconly-Bulk-Plus")
                            .resizable()
                            .frame(width:23,
                                   height:23,
                                   alignment:.center)

                    })
                
                .navigationBarItems(leading:  NavigationLink(
                    destination: photosTogetherUIView(imageTogether: imageTogether,album:album).onAppear(perform: {
                        imageTogether.loadFamilyTreeId()
                        }))
                    {
                        Image("orange photo")
                            .resizable()
                            .frame(width:23,
                                   height:23,
                                   alignment:.center)

                    })
        }
//            .navigationBarTitle("",displayMode: .inline)
//            .navigationBarHidden(true)
//            .navigationTitle("返回"))
//            .onAppear(perform: )
    }
                            
    private func loadData() {
//        var tempItems: [Item] = []
//        for index in 0..<10 {
//            if index >= itemsData.count {
//                // 如果已经没有数据，则终止添加
//                listState.setNoMore(true)
//                break
//            }
//            let item = itemsData[index]
//
//            tempItems.append(item)
//        }
//        self.items = tempItems
        let query = LCQuery(className: "familyAlbum")
        query.whereKey("familyId",.equalTo(album.treeId))
        let count = query.count()
        if (album.dateNeed.count>=count.intValue){
            listState.setNoMore(true)
        }else{
            album.skip = 0
            print("😊😊😊\(album.skip)")
            album.dateNeed = []
            album.updateDateNeed()
        }
    }
    
    private func reloadData() {
        print("begin refresh data ...\(headerRefreshing)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loadData()
            headerRefreshing = false
            print("end refresh data ...\(headerRefreshing)")
        }
    }
    
    private func loadMoreData() {
        print("begin load more data ... \(footerRefreshing)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let query = LCQuery(className: "familyAlbum")
                query.whereKey("familyId",.equalTo(album.treeId))
                let count = query.count()
                if  album.dateNeed.count >= count.intValue {
                    // 如果已经没有数据，则终止添加
                    listState.setNoMore(true)
                    footerRefreshing = false
                }else{
                    album.updateDateNeed()
                }
            }
            footerRefreshing = false
            print("end load more data ... \(footerRefreshing)")
    }
}

struct ImageUIView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUIView(album:Album())
    }
}
