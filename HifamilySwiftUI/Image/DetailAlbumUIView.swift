//
//  DetailAlbumUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/21.
//

import SwiftUI

struct DetailAlbumUIView: View {
//    @State
    @Binding
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
    
    var body: some View {
            
        ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    
                    HStack{
                   
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fill)
                            .foregroundColor(Color("AccentColor"))
                            .onTapGesture {
                                isSelected1 = false
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                            .offset(x: 10, y: -280)
                    }
                    
                ForEach( 1 ..< 10){ i in
                    VStack{

                        HStack {
                            Image("Hi family").padding(EdgeInsets(top: 20, leading: 15, bottom: 0, trailing: 0))
                            Spacer()
                        }
                        Image("\(detailAlbum)\(i)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 250,height: 400)
                            .cornerRadius(20)
                            .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                        HStack{
                            Text("时光记录人: 妍妍")
                                .foregroundColor(grayColor2)
                                .font(.system(size: 23))
                            Spacer()
                        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 0))
                        
                        Text(detailText).foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
                            .frame(alignment: .leading)
                        HStack{
                            Spacer()
                            Text("上传时间：2021.7.27 AM10:02").foregroundColor(grayColor).padding(EdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 15))
                                .font(.system(size: 15))
                        }

                    }
                    .frame(width: 280)
                    .background(Color(white: 0.99))
                    .overlay(RoundedRectangle(cornerRadius: 15.0, style: .continuous   ).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                    .cornerRadius(15)
                    .shadow(color: .gray, radius: 10, x: 0, y: 3)
                    .animation(.easeInOut)
        .frame(width: 300, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 15))
                }
            }
            }
        }
    }

//
//struct DetailAlbumUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailAlbumUIView()
//    }
//}
