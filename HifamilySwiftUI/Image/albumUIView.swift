//
//  albumUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI
import LeanCloud
import Kingfisher
struct ImageContent{
    var Content : String
    var person : String
    var image : String
    var createdAt : Date
    var UserObjectId : String
}

final class Album : ObservableObject{
    @Published var dateNeed : [ImageContent]
    @Published var skip = 0
    @Published var treeId : Int
    init(){
        dateNeed = []
        skip = 0
        treeId = 0
    }
    func update(){
        let user = LCApplication.default.currentUser?.objectId?.stringValue!
        let query = LCQuery(className: "_User")
        query.whereKey("objectId", .equalTo(user!))
        _ = query.getFirst() { result in
            switch result {
            case .success(object: let person):
                self.treeId = (person.familyTreeId?.intValue!)!
                break
            case .failure(error: let error):
                print(error)
            }
        }
    }
    func updateDateNeed(){
        let query = LCQuery(className: "familyAlbum")
        query.whereKey("familyId",.equalTo(self.treeId))
        query.whereKey("createdAt",.descending)
        query.skip=self.skip
        query.limit=20
        _ = query.find() { result in
            switch result {
            case .success(objects: let person):
                self.skip=self.skip+20
                for item in person{
                    let imageContent = ImageContent(Content: (item.Content?.stringValue!)!, person: (item.person?.stringValue!)!, image: (item.url?.stringValue!)!, createdAt: (item.createdAt?.dateValue!)!, UserObjectId: (item.UserObjectId?.stringValue!)!)
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
    @ObservedObject var album : Album = Album()
    @Binding var detailImage : String
    @Binding var detailText : String
    @Binding var isSelected : Bool
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1),
        GridItem(GridItem.Size.flexible(),spacing: 1)
    ]
    
    var body: some View {
        
        VStack{
            HStack{
                HStack{
                }
                .frame(width: 3, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color("AccentColor"))
                VStack{
                Text("分享家庭照片，定格美好瞬间")
                    .kerning(2.0)
                    .frame(width: 200, height: 25, alignment: .topLeading)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                )
                
            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        
            LazyVGrid(columns: items, content: {
//                ForEach(1..<10){
//                    indexsecond in
//                    Button(action:{
//                        isSelected = true
//                        detailImage = imgTest.img[index]+"\(indexsecond)"
//                        detailText = "弟弟，你还记得那天你小学四年级军训的时候要上台表演，在台下紧张的等待，我悄悄给你拍的照片。"
//                    }){
//                        Image("\(imgTest.img[index])\(indexsecond)")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 85, height: 85, alignment: .center)
//                            .cornerRadius(20)
//                    }
//                }
//                ForEach(0..<album.dateNeed.count){_ in
////                    UIImageView{
//                    let url = URL(string: "https://example.com/high_resolution_image.png")
//                    let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
//                                 |> RoundCornerImageProcessor(cornerRadius: 20)
//                    imageView.kf.indicatorType = .activity
//                    imageView.kf.setImage(
//                        with: url,
//                        placeholder: UIImage(named: "placeholderImage"),
//                        options: [
//                            .processor(processor),
//                            .scaleFactor(UIScreen.main.scale),
//                            .transition(.fade(1)),
//                            .cacheOriginalImage
//                        ])
//                    {
//                        result in
//                        switch result {
//                        case .success(let value):
//                            print("Task done for: \(value.source.url?.absoluteString ?? "")")
//                        case .failure(let error):
//                            print("Job failed: \(error.localizedDescription)")
//                        }
//                    }
//                    }
//                }
            })
        }
    }
}
}
//struct albumUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        albumUIView(detailImage: String, detailText: String)
//    }
//}
