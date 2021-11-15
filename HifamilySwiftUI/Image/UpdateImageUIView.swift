//
//  UpdateImageUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/11/14.
//

import SwiftUI
import Kingfisher
import LeanCloud

struct UpdateImageUIView: View {
    @ObservedObject var imgTest : Image1 = Image1()
    @ObservedObject var album : Album
//    @Binding var detailImage : String
//    @Binding var detailText : String
//    @Binding var isSelected : Bool
    @ObservedObject  var imageTogether1 : ImageTogether1
//    @Binding var selectWho : Int
//    @State private var isRefreshing : Bool = false
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
//                        isSelected = true
//                        selectWho = index
                        print("1231231231\(index)")
                        if(imageTogether1.selectedObjectId.contains(album.dateNeed[index].objectId)){
                            imageTogether1.selectedObjectId.remove(album.dateNeed[index].objectId)
                            imageTogether1.albumIndex.remove(index)
//                            album.dateNeed[index].isSelected = false
                        }else{
//                            album.dateNeed[index].isSelected = true
                            imageTogether1.albumIndex.insert(index)
                            imageTogether1.selectedObjectId.insert(album.dateNeed[index].objectId)
                        }
                    }){
//                    ZStack{
//                        ZStack{

//
//                        }
//                    }
                        ZStack(alignment: .bottomTrailing){
                            if(imageTogether1.selectedObjectId.contains(album.dateNeed[index].objectId)){
                                Rectangle()
                                    .frame(width: 115, height: 115)
                                    .cornerRadius(8)
                                    .opacity(0.2)
                            }
                            KFImage.url(URL(string:album.dateNeed[index].image))
                                .placeholder { Image("cat_walk") }
                            //                              .placeholder(UIImageView().image(UIImage("")))
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
                                .cornerRadius(8)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 115, height: 115, alignment: .center)
                            if(imageTogether1.selectedObjectId.contains(album.dateNeed[index].objectId)){
                                
                                ZStack{
                                    Rectangle()
                                    .foregroundColor(Color.blue)
                                    .frame(width: 25, height: 25)
                                    .border(Color.white)
                                    .opacity(0.8)
                                    .cornerRadius(2)
                                    Image("right").frame(width: 20, height: 20 )
                                    
                                }
                            }else{
//                                ZStack{
//                                    Rectangle()
//                                    .foregroundColor(Color.blue)
//                                    .frame(width: 25, height: 25)
//                                    .cornerRadius(7)
//                                    .border(Color.white)
//                                    .opacity(0.8)
//                                    Image("right").frame(width: 20, height: 20 )
//
//                                }
                                Rectangle()
                                .foregroundColor(Color.gray)
                                .frame(width: 25, height: 25)
                                .border(Color.white)
                                .opacity(0.4)
                                .cornerRadius(2)
                            }
                        }
                    }
                }
            })
          
        }
    }
}
//
//struct UpdateImageUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateImageUIView()
//    }
//}
