//
//  photosTogetherUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/10/28.
//

import SwiftUI
import LeanCloud
import Kingfisher

struct ImageT{
    var  albumName : String
    var  objectId : String
    var  familyId : Int
    var  frontPhoto : String
    var  createAt : Date
}
final class ImageTogether : ObservableObject{
    @Published var ImageTo : [ImageT]
    @Published var familyId : Int
    @Published var selectedObjectId : Set<String>
    @Published var albumName : String
    @Published var frontPhoto : String
    init(){
        ImageTo = []
        familyId = 0
        selectedObjectId = []
        albumName = ""
        frontPhoto = ""
    }
    func loadFamilyTreeId(){
        
        let user = LCApplication.default.currentUser?.objectId?.stringValue!
        let query = LCQuery(className: "_User")
        query.whereKey("objectId", .equalTo(user!))
        _ = query.getFirst() { result in
            switch result {
            case .success(object: let person):
                self.familyId = (person.familyTreeId?.intValue!)!
                print("树名\((person.familyTreeId?.intValue!)!)")
                self.ImageTo = []
                self.loadFamilyContent()
                break
            case .failure(error: let error):
                print(error)
            }
        }
    }
    func loadFamilyContent(){
        let query = LCQuery(className: "familyImage")
        query.whereKey("familyId",.equalTo(self.familyId))
        query.whereKey("createdAt",.descending)
        _ = query.find() { result in
            switch result {
            case .success(objects: let person):
                for item in person{
                   
                    let imageT = ImageT(albumName: (item.albumName?.stringValue!)!, objectId: (item.objectId?.stringValue!)!, familyId: (item.familyId?.intValue!)!,frontPhoto: (item.frontPhoto?.stringValue!)!,createAt: (item.createdAt?.dateValue!)!)
                    self.ImageTo.append(imageT)
                }
                break
            case .failure(error: let error):
                print(error)
            }
    }
  }
}

var item1s : [GridItem] = [
    GridItem(GridItem.Size.flexible(),spacing: 5),
    GridItem(GridItem.Size.flexible(),spacing: 5),
    GridItem(GridItem.Size.flexible(),spacing: 5)
]

struct photosTogetherUIView: View {
    @State var isPresented = false
    @ObservedObject  var imageTogether : ImageTogether
    @ObservedObject  var imageTogether1 : ImageTogether1 = ImageTogether1()
    @ObservedObject var album : Album
    @ObservedObject var imageOfAlbum : ImageOfAlbum = ImageOfAlbum()
  
    @State var albumIndex = -1
    @State var text123:[String]=["","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""]
    @State var isSelected1 : Bool = false
    var body: some View {
        ZStack{
        ScrollView(.vertical){
        VStack{
            HStack{
                HStack{
                }
                .frame(width: 3, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color("AccentColor"))
                Text("自定义相册")
                    .kerning(2.0)
                    .frame(width: 200, height: 25, alignment: .topLeading)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
        LazyVGrid(columns: item1s, content: {
            ForEach(0 ..< imageTogether.ImageTo.count,id: \.self){
                index in
                VStack{
                Button(action:{
                    isSelected1 = true
                    imageOfAlbum.updateImageOfAlbum(imageObjectId1: imageTogether.ImageTo[index].objectId,imageTogether1: imageTogether1)
//                    for item in imageOfAlbum.updateImageOfAlbum(imageObjectId1: imageTogether.ImageTo[index].objectId){
////                        print("😊😊😊😊😊😊babab3123123😊😊😊😊😊😊😊😊😊😊😊😊😊\(item.objectId)")
//                        imageTogether1.selectedObjectId.insert(item);
//                        print("😊😊😊😊😊😊babab222222222222😊😊😊😊😊😊😊😊😊😊😊😊😊\(item)")
//                    }
                    albumIndex = index
                }){
                    
                    KFImage.url(URL(string:imageTogether.ImageTo[index].frontPhoto))
//                              .placeholder(UIImage("AppIcon"))
//                              .setProcessor(processor)
                              .loadDiskFileSynchronously()
                              .cacheOriginalImage()
//                              .cacheMemoryOnly()
                              .fade(duration: 0.25)
//                              .lowDataModeSource(.network(lowResolutionURL))
                        .onProgress { receivedSize, totalSize in  }
                        .onSuccess { result in  }
                        .onFailure { error in }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 110, height: 110, alignment: .center)
                        .cornerRadius(20)
                        .padding(EdgeInsets(top: 0 , leading: 20,bottom:0,trailing: 20))
//                                .border(Color.lack)
                }
                    HStack{
                        TextField("\(imageTogether.ImageTo[index].albumName)", text: $text123[index],onCommit: {
                            do {
                                let todo = LCObject(className: "familyImage", objectId: imageTogether.ImageTo[index].objectId)
                                try todo.set("albumName", value: text123[index])
                                todo.save { (result) in
                                    switch result {
                                    case .success:
                                        break
                                    case .failure(error: let error):
                                        print(error)
                                    }
                                }
                            } catch {
                                print(error)
                            }

                        }).multilineTextAlignment(.center)
                            .foregroundColor(grayColor).frame(width: 110, alignment: .center)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
            NavigationLink(
                destination: SelectImageToAlbum(album: album, imageTogether:imageTogether, detailImage: "", detailAlbum: "", detailText: "", isSelected: false, isSelected1: false, SelectWho: 0))
                {
                    VStack{
                    VStack{
                    Image("paper plus")
                        .resizable()
                        .frame(width: 95/*@END_MENU_TOKEN@*/, height: 95, alignment: /*@START_MENU_TOKEN@*/.center)
                        
                    } .frame(width: 110, height: 110, alignment: .center)
                        .cornerRadius(20)
                        .background(Color(red: 245/255, green: 245/255, blue: 245/255)).cornerRadius(20)
                    HStack{
                        Text("新建相册").foregroundColor(grayColor).frame(width: 110, alignment: .center)
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                }
//            Button(action:{
//                isPresented = true
//            }){
//
//            }
//            .frame(width: 120, height: 120, alignment: .center)
//            .cornerRadius(20)
//            .background(Color(red: 245/255, green: 245/255, blue: 245/255)).cornerRadius(20)
//        })
    })
  }
        }
            if(isSelected1){
                Rectangle().fill(Color.gray).opacity(0.5)
                ContentOfAlbumSwiftUIView(isSelected1: $isSelected1, imageOfAlbum: imageOfAlbum,album:album,imageTogether:imageTogether,imageTogether1:imageTogether1)
                }
            }
    }
        
}


struct photosTogetherUIView_Previews: PreviewProvider {
    static var previews: some View {
        photosTogetherUIView(imageTogether: ImageTogether(),album:Album())
    }
}
