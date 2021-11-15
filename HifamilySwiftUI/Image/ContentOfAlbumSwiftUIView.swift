//
//  ContentOfAlbumSwiftUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/11/10.
//

import SwiftUI
import LeanCloud
import Kingfisher

struct ImageOfAlbumContent{
    var Content : String
    var person : String
    var image : String
    var createdAt : String
    var UserObjectId : String
    var objectId : String
    var flipped : Bool = false
    var animate3d : Bool = false
}

final class ImageOfAlbum: ObservableObject {
    @Published var imageOfAlbum : [ImageOfAlbumContent]
    @Published var imageObjectId : String
    @Published var objectID : [String]
    init(){
        imageOfAlbum = []
        imageObjectId = ""
        objectID = []
    }
    
    func updateObjectId( imageObjectId : String?){
        self.imageObjectId = (imageObjectId?.stringValue)!
    }
    func updateImageOfAlbum(imageObjectId1 : String,imageTogether1 : ImageTogether1){
        self.imageOfAlbum = []
        self.imageObjectId = (imageObjectId1.stringValue)!
        self.objectID = []
        let query = LCQuery(className: "AlbumAndImage")
//        query.whereKey("objectId", .equalTo(user!))
        query.whereKey("imageObjectId",.equalTo(imageObjectId1));
        print("wodetiana \((imageObjectId1.stringValue!))")
        _ = query.find() { result in
            switch result {
            case .success(objects: let images):
                for item in images{
                    let query1 = LCQuery(className:"familyAlbum")
                    query1.whereKey("objectId",.equalTo((item.albumObjectId?.stringValue)!))
                    print("wodetiana \((item.albumObjectId?.stringValue!)!)")
                    _ = query1.getFirst(){
                        result1 in
                        switch result1{
                        case .success(object: let img):
//                            let imageOfAlbum = ImageOfAlbumContent(Content: img., person: "", image: "", createdAt: "", UserObjectId: "", objectId: (item.imageObjectId?.stringValue!)!)
                            let imageOfAlbumContent = ImageOfAlbumContent(Content: (img.Content?.stringValue!)!, person: (img.person?.stringValue!)!, image: (img.url?.stringValue!)!, createdAt: formattedDate(date1: (img.createdAt?.dateValue!)!), UserObjectId: (img.UserObjectId?.stringValue!)!,objectId: (img.objectId?.stringValue!)!)
                            self.objectID.append((img.objectId?.stringValue!)!)
                            imageTogether1.selectedObjectId.insert((img.objectId?.stringValue!)!)
//                            print("objectID:\(self.objectID.count)💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗\((img.objectId?.stringValue!)!)")
//                            print("objectID:\(self.objectID.count)💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗")
                            self.imageOfAlbum.append(imageOfAlbumContent)
                            
                            break
                        case .failure(error: let error1):
                            print(error1)
                        }
                    }
                }
//                return self.objectID
           
            case .failure(error: let error):
                print(error)
            }
        }
//        print("objectID:\(self.objectID.count)💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗💗")
//        return self.objectID
    }
}

struct ContentOfAlbumSwiftUIView: View {
    @Binding var isSelected1 : Bool
    @State private var flipped = false
    @State private var animate3d = false
    @ObservedObject var imageOfAlbum : ImageOfAlbum
    @State private var indexNum = 0
    @ObservedObject var album : Album
   
    @ObservedObject var imageTogether : ImageTogether
    @ObservedObject var imageTogether1 : ImageTogether1 
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false){
               
//                VStack{
//                    HStack{
//
//                        Image(systemName: "arrowshape.turn.up.left.fill")
//                            .resizable(resizingMode: .tile)
//                            .aspectRatio(contentMode: .fill)
//                            .foregroundColor(Color("AccentColor"))
//                            .onTapGesture {
//                                isSelected1 = false
//                            }
//                            .frame(width: 30, height: 30, alignment: .center)
//                            .offset(x: 10, y: -280)
//                    }
//
//                    ForEach( 0 ..< imageOfAlbum.imageOfAlbum.count){ i in
//
//                    }
//                }
                HStack{
                   
                    ForEach( 0 ..< imageOfAlbum.imageOfAlbum.count, id: \.self){ index in
                        VStack {
                            HStack{
                            Image(systemName: "arrowshape.turn.up.left.fill")

                                .resizable(resizingMode: .tile)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color("AccentColor"))
                                .onTapGesture {
                                    isSelected1 = false
                                }
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .offset(x: 30, y: 100)
//                                .debugPrint("😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊\(imageOfAlbum.imageOfAlbum.count)")
                                .debugPrint("😊😊😊😊😊😊babab😊😊😊😊😊😊😊😊😊😊😊😊😊\(imageTogether1.selectedObjectId.count)")
//                              Spacer()
                                NavigationLink(destination:SwiftUpdateUIView(album:album, imageTogether1: imageTogether1, imageTogether:imageTogether,isSelected1: $isSelected1, imageObjectId: $imageOfAlbum.imageObjectId)){
                                Image(systemName:"plus")
                                    .resizable(resizingMode: .tile)
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color("AccentColor"))
                                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                                    .padding(EdgeInsets(top: 100, leading: 360, bottom: 0, trailing: 0))
//                                    .offset(x: 360, y: 100)
//                                    .onTapGesture(perform: {})
                                }.offset(x: 360, y: 100)
                                    
                            }
                            Spacer()
                        }
                        ZStack() {
                            FrontCard1(image123: $imageOfAlbum.imageOfAlbum[index]).opacity(imageOfAlbum.imageOfAlbum[index].flipped ? 0.0 : 1.0)
//                                .debugPrint("😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊\((imageOfAlbum.imageOfAlbum[index].objectId.stringValue)!)")
                            BackCard1(image123: $imageOfAlbum.imageOfAlbum[index]).opacity(imageOfAlbum.imageOfAlbum[index].flipped ? 1.0 : 0.0)
                        } .modifier(FlipEffect(flipped: $imageOfAlbum.imageOfAlbum[index].flipped, angle: imageOfAlbum.imageOfAlbum[index].animate3d ? 180 : 0, axis: (x: 1, y: 0)))
                            .onTapGesture {
                                  withAnimation(Animation.linear(duration: 0.8)) {
                                      imageOfAlbum.imageOfAlbum[index].animate3d.toggle()
                                  }
                            }
                    }
//                      .modifier(FlipEffect(flipped: $flipped, angle: animate3d ? 180 : 0, axis: (x: 1, y: 0)))
//                      .onTapGesture {
//                            withAnimation(Animation.linear(duration: 0.8)) {
//                                  self.animate3d.toggle()
//                            }
//                      }
//                      Spacer()
                }
            }
        }
    }
}

struct FrontCard1 : View {
//    @ObservedObject var imageOfAlbum:ImageOfAlbum
    @Binding var image123: ImageOfAlbumContent
//    @Binding var index:Int
      var body: some View {
        VStack{
            KFImage.url(URL(string:image123.image))
//                              .placeholder(UIImage("AppIcon"))
//                              .setProcessor(processor)
                      .loadDiskFileSynchronously()
                      .cacheMemoryOnly()
                      .fade(duration: 0.25)
//                              .lowDataModeSource(.network(lowResolutionURL))
                      .onProgress { receivedSize, totalSize in  }
                      .onSuccess { result in  }
                      .onFailure { error in }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350,height:350)
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        } .frame(width: 350,height: 350)
        .background(Color(white: 0.99))
        .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
//            Text("One thing is for sure – a sheep is not a creature of the air.").padding(5).frame(width: 250, height: 150, alignment: .center).background(Color.yellow)
      }
}

struct BackCard1 : View {
//    @ObservedObject var imageOfAlbum:ImageOfAlbum
//    @Binding var index:Int
    @Binding var image123: ImageOfAlbumContent
      var body: some View {
        VStack{
            HStack {
                Image("Hi family").padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 0))
                Spacer()
            }
        HStack{
            Text("时光记录人: \(image123.person)")
                .foregroundColor(Color("AccentColor"))
                .font(.system(size: 38))
            Spacer()
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 5, trailing: 0))
                    ScrollView(.vertical){
                        Text("\(image123.Content)").foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
            .font(.system(size: 25))
                    }
//                        .lineSpacing(12.0)
        HStack{
            Spacer()
            Text("上传时间:\(image123.createdAt)").foregroundColor(Color("AccentColor")).padding(EdgeInsets(top: 5, leading: 0, bottom: 1, trailing: 15))
                .font(.system(size: 20))
        }
      } .frame(width: 350,height: 350)
        .background(Color(white: 0.99))
        .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
        .cornerRadius(15)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
      }
}
