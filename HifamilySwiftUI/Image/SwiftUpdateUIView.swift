

import SwiftUI
import LeanCloud


struct SwiftUpdateUIView: View {
    @ObservedObject var album:Album
    @State private var headerRefreshing: Bool = false
    @State private var footerRefreshing: Bool = false
    @ObservedObject var imageTogether1 : ImageTogether1
    @ObservedObject  var imageTogether : ImageTogether
    @Binding var isSelected1 : Bool
    @Binding var imageObjectId : String
    @State private var listState = ListState()
    @State var detailImage : String = " "
    @State var detailAlbum : String = " "
    @State var detailText : String = " "
    @State var isSelected : Bool = false
//    @State var isSelected1 : Bool = false
    @State var SelectWho : Int = 1
    @State var isIssue : Bool = false
    @State var notice : Bool = false
    var body: some View {
            VStack{
               ScrollView(.vertical, showsIndicators: false){
                      Divider()
                   VStack{
                        PullToRefreshView(header: RefreshDefaultHeader(), footer: RefreshDefaultFooter()) {
                            UpdateImageUIView(album: album, imageTogether1:imageTogether1).onAppear(perform: {isSelected1 = false})
                        }.environmentObject(listState)
                    }
                }
        }
        .addPullToRefresh(isHeaderRefreshing: $headerRefreshing, onHeaderRefresh: reloadData,
                                 isFooterRefreshing: $footerRefreshing, onFooterRefresh: loadMoreData)
        .navigationBarTitle("éĉİç§ç",displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{
            if(imageTogether1.selectedObjectId.count==0){
                notice = true
            }
            else{
                self.isIssue.toggle()
//                var albumAndImageObjectd : [String] = []
                isSelected1 = false
                var frontIndex = -1
                for num in imageTogether1.albumIndex.sorted() {
                    if(frontIndex == -1){
                       frontIndex = num
                       break
                    }
                }
                do{
                    let query = LCQuery(className: "AlbumAndImage")
                    query.whereKey("imageObjectId", .equalTo(imageObjectId))
                    _ = query.find { result in
                        switch result {
                        case .success(objects: let students):
                            var objects1:[LCObject] = []
                            for item in students{
                                let todo = LCObject(className: "AlbumAndImage", objectId: item.objectId!)
                                objects1.append(todo)
                            }
                            _ = LCObject.delete(objects1, completion: { (result) in
                                switch result {
                                case .success:
                                    var obj: [LCObject] = []
                                    do{
                                        print("?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż\(imageTogether1.selectedObjectId.count)")
                                        for obj1 in imageTogether1.selectedObjectId{
                                            print("123123123123123123123123123ĉĉŻäşş3")
                                            let obj2 = LCObject(className: "AlbumAndImage")
                                            try obj2.set("imageObjectId", value: imageObjectId)
                                            try obj2.set("albumObjectId",value: obj1.stringValue!)
                                            obj.append(obj2)
//                                            print("?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż\(objects.count)")
                                        }
                                        _ = LCObject.save(obj, completion: { (result) in
                                            switch result {
                                            case .success:
                                                imageTogether1.selectedObjectId.removeAll()
                                                imageTogether1.albumIndex.removeAll()
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        })
                                    }  catch{
                                        print(error)
                                    }
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                            })
                            
                            break
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                }
//                do {
//                    // ĉċğşċŻıèħĦ
//                    let todo = LCObject(className: "familyImage")
//                    let uuid = UUID().uuidString
//                    // ä¸şċħĉ§èµċĵ
//                    try todo.set("albumName", value: imageTogether1.albumName)
//                    try todo.set("familyId", value: imageTogether.familyId)
//                    try todo.set("frontPhoto", value: album.dateNeed[frontIndex].image)
//                    try todo.set("uuid",value:uuid)
//                    // ċ°ċŻıèħĦäżċ­ċ°äşçĞŻ
//                    _ = todo.save { result in
//                        switch result{
//                        case .success:
//                            let query = LCQuery(className: "familyImage")
//                            print("123123123123123123123123123ĉĉŻäşş2")
//                            query.whereKey("uuid", .equalTo(uuid))
//                            _ = query.getFirst() { result in
//                                switch result {
//                                case .success(object: let students):
//                                    let objectId = students.objectId;
//                                    print("?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż?Ż\((objectId?.stringValue!)!)")
                                   
//
                              
//                                    break
//                                case .failure(error: let error):
//                                    print(error)
//                                }
//                            }
//                            break
//                        case .failure(error: let error):
//                            // ċĵċ¸¸ċ¤ç
//                            print(error)
//                        }
//                    }
//                } catch {
//                    print(error)
//                }
               
            }
        })
            {
            Text("ċċ¸").alert(isPresented: $isIssue, content: {
                Alert(title:Text( notice ?"èŻ·éĉİċ?ç":"ä¸äĵ ĉċ"))
            })
            })
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
                    // ċĤĉċ·²çğĉ²Ħĉĉ°ĉ?ïĵċçğĉ­˘ĉ·ğċ 
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

