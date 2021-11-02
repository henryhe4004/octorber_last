//
//  SelectImageToAlbum.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/11/1.
//

import SwiftUI
import LeanCloud


struct SelectImageToAlbum: View {
    @ObservedObject var album:Album
    @State private var headerRefreshing: Bool = false
    @State private var footerRefreshing: Bool = false
    @ObservedObject  var imageTogether : ImageTogether
    @ObservedObject var imageTogether1 : ImageTogether1 = ImageTogether1()
    @State private var listState = ListState()
    @State var detailImage : String = " "
    @State var detailAlbum : String = " "
    @State var detailText : String = " "
    @State var isSelected : Bool = false
    @State var isSelected1 : Bool = false
    @State var SelectWho : Int = 1
    var body: some View {
            VStack{
               ScrollView(.vertical, showsIndicators: false){
                      Divider()
                   VStack{
                        PullToRefreshView(header: RefreshDefaultHeader(), footer: RefreshDefaultFooter()) {
                            SelectImageToAlbumDetailView(album: album, detailImage: $detailImage, detailText: $detailText,isSelected: $isSelected, imageTogether1:imageTogether1, selectWho:$SelectWho).onAppear(perform: imageTogether1.loadFamilyTreeId)
                        }.environmentObject(listState)
                    }
                }
        }
        .addPullToRefresh(isHeaderRefreshing: $headerRefreshing, onHeaderRefresh: reloadData,
                                 isFooterRefreshing: $footerRefreshing, onFooterRefresh: loadMoreData)
        .navigationBarTitle("选择照片",displayMode: .inline)
        .
        }

    
                            
    private func loadData() {

        let query = LCQuery(className: "familyAlbum")
        query.whereKey("familyId",.equalTo(album.treeId))
        let count = query.count()
        if (album.dateNeed.count>=count.intValue){
            listState.setNoMore(true)
        }else{
            album.skip = 0
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


struct SelectImageToAlbum_Previews: PreviewProvider {
    static var previews: some View {
        SelectImageToAlbum(album:Album(),imageTogether: ImageTogether())
    }
}
