//
//  albumUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI
import LeanCloud
import Kingfisher

extension String {
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
        if let date = dateFormatter.date(from: self) {
            print(date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
func formattedDate(date1:Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZ"
    if let date = dateFormatter.date(from: dateFormatter.string(from: date1)) {
        print(date)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    return ""
}
struct ImageContent{
    var Content : String
    var person : String
    var image : String
    var createdAt : String
    var UserObjectId : String
    var objectId : String
    var isSelected : Bool = false
}

final class Album : ObservableObject{
    @Published var dateNeed : [ImageContent]
    @Published var skip = 0
    @Published var treeId : Int
    @Published var count : Int
//    @Published var skip : Int
    init(){
        dateNeed = []
        skip = 0
        treeId = 0
        count = 0
    }
    func update(){
        if(self.treeId==0){
        let user = LCApplication.default.currentUser?.objectId?.stringValue!
        let query = LCQuery(className: "_User")
        query.whereKey("objectId", .equalTo(user!))
        _ = query.getFirst() { result in
            switch result {
            case .success(object: let person):
                self.treeId = (person.familyTreeId?.intValue!)!
                print("树名\((person.familyTreeId?.intValue!)!)")
                self.updateDateNeed()
                break
            case .failure(error: let error):
                print(error)
            }
        }
        }
        else{
            updateDateNeed()
        }
    }
    func updateDateNeed(){
        let query = LCQuery(className: "familyAlbum")
        query.whereKey("familyId",.equalTo(self.treeId))
        print("123123123saddasd13afsfgsdgewrgerg\(self.treeId)")
        query.whereKey("createdAt",.descending)
        query.skip=self.skip
        query.limit=21
        _ = query.find() { result in
            switch result {
            case .success(objects: let person):
                print("代码执行3213123123123123123123123123123123123")
                print(person)
                self.skip=self.skip+20
                print("😊😊😊skip:\(self.skip)")
                for item in person{
                    let imageContent = ImageContent(Content: (item.Content?.stringValue!)!, person: (item.person?.stringValue!)!, image: (item.url?.stringValue!)!, createdAt: formattedDate(date1: (item.createdAt?.dateValue!)!), UserObjectId: (item.UserObjectId?.stringValue!)!,objectId: (item.objectId?.stringValue!)!)
                    self.dateNeed.append(imageContent)
                }
                break
            case .failure(error: let error):
                print(error)
            }
    }
    }
}


struct albumUIView: View {
    @ObservedObject var imgTest : Image1 = Image1()
    @ObservedObject var album : Album 
    @Binding var detailImage : String
    @Binding var detailText : String
    @Binding var isSelected : Bool
    @Binding var selectWho : Int
    @State private var isRefreshing : Bool = false
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1)
    ]
 
    var body: some View {
       
        LazyVStack{
//            HStack{
//                HStack{
//                }
//                .frame(width: 3, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                .background(Color("AccentColor"))
//
//                Text("分享家庭照片，定格美好瞬间")
//                    .kerning(2.0)
//                    .frame(width: 350, height: 25, alignment: .topLeading)
//                    .font(.system(size: 20))
//                    .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
//                    .padding(EdgeInsets(top: 0, leading:0, bottom: 0, trailing: 0))
//                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//            .debugPrint(album.dateNeed.count)
            LazyVGrid(columns: items, content: {
                ForEach(0..<album.dateNeed.count,id: \.self){
                    index in
                    Button(action:{
                        isSelected = true
                        selectWho = index
                        print("1231231231\(index)")
                    }){
                    KFImage.url(URL(string:album.dateNeed[index].image))
                            .placeholder{  Image("cat_walk")}
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
                        .frame(width: 115, height: 115, alignment: .center)
                        .cornerRadius(20)
                    }
                }
            })
          
        }
    }
}
//}

//struct albumUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        albumUIView(detailImage: String, detailText: String)
//    }
//}
