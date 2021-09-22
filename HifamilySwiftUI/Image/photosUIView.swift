//
//  photosUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI

struct photosUIView: View {
    
    @ObservedObject var albumTest : Album1 = Album1()
    @Binding
//    @State
    var detailAlbum : String
//        = "littleYou"
    @Binding
//    @State
    var detailText : String
//        = "123"
    @Binding
//    @State
    var isSelected1 : Bool
//        = false
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 2),
        GridItem(GridItem.Size.flexible(),spacing: 2),
        GridItem(GridItem.Size.flexible(),spacing: 2)
    ]
    var body: some View {
        VStack{
            HStack{
                HStack{
                }
                .frame(width: 3, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color("AccentColor"))
                Text("时光记录人")
                    .kerning(2.0)
                    .frame(width: 200, height: 25, alignment: .topLeading)
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    Spacer()
                
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
//         Spacer()
                LazyVGrid(columns: items, content: {
                    ForEach(0 ..< albumTest.imga.count){
                        index1 in
                        VStack{
                        Button(action:{
                            isSelected1 = true
                            detailText = "弟弟，你还记得那天你小学四年级军训的时候要上台表演，在台下紧张的等待，我悄悄给你拍的照片。"
                            detailAlbum = albumTest.imga[index1]
                        }){
                            
                            Image("\(albumTest.imga[index1])2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110, alignment: .center)
                                .cornerRadius(20)
//                                .border(Color.lack)
                        }
                            HStack{
                                Text("\(albumTest.persona[index1])").foregroundColor(grayColor)
                                Spacer()
                            }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        }
                    }
                }
                
                )
            
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
//         Spacer()
                LazyVGrid(columns: items, content: {
                    ForEach(0 ..< albumTest.imga1.count){
                        index2 in
                        VStack{
                        Button(action:{
                            isSelected1 = true
                            detailText = "弟弟，你还记得那天你小学四年级军训的时候要上台表演，在台下紧张的等待，我悄悄给你拍的照片。"
                            detailAlbum = albumTest.imga1[index2]
                        }){
//                            Text("\(albumTest.imga1[index2])1")
//                                .padding()
//                                .frame(width:120)
                            Image("\(albumTest.imga1[index2])2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 110, height: 110, alignment: .center)
                                .cornerRadius(20)
//                                .border(Color.lack)
                        }
                            HStack{
                                Text("\(albumTest.Album[index2])").foregroundColor(grayColor)
                                Spacer()
                            }.padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 0))
                        }
                    }
                }
            )
        }
    }
}

//struct photosUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        photosUIView()
//        
//    }
//}
