//
//  ImageUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI

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
    //默认为照片
    @State var detailImage : String = " "
    @State var detailAlbum : String = " "
    @State var detailText : String = " "
    @State var isSelected : Bool = false
    @State var isSelected1 : Bool = false
    var body: some View {
       
        NavigationView {
            
        VStack{
            
            ZStack {
                HStack{
                Image("Iconly-Bulk-Setting")
                    .resizable()
                    .frame(width:23,
                           height:23,
                           alignment:.center)
                Spacer()
                Text("Family album")
                    .foregroundColor(Color("AccentColor"))
                    .font(.system(size: 18))
                Spacer()
                NavigationLink(
                    destination: IssueUIView())
                {
                    Image("Iconly-Bulk-Plus")
                        .resizable()
                        .frame(width:23,
                               height:23,
                               alignment:.center)
                    
                }.navigationBarTitle("",displayMode: .inline)
                .navigationBarHidden(true)
                .navigationTitle("返回")
                
                    
                }
                
            }.padding()
            Divider()
            HStack{
                  
                    Button(action: {
                       
                            indexSelected=1
                        
                        
                    }){
                        HStack {
                            Image(indexSelected == 1 ? "c1" : "gray camera" )
                            Text("照片")
                            .frame(width: 40, height: 20, alignment: .center)
                            .cornerRadius(32)
                            .foregroundColor( grayColor )
                        }
                
                    }
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .animation(.easeInOut)
                .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                    .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 5, trailing: 20))
                Button(action: {
                    
                        indexSelected=2
                    
                    
                }){
                    HStack {
                        Image(indexSelected == 2 ? "orange photo" : "c2" )
                        Text("相册")
                        .frame(width: 40, height: 20, alignment: .center)
                        .cornerRadius(32)
                        .foregroundColor( grayColor )
                    }
            
                }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .animation(.easeInOut)
            .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
                
                Button(action: {
                  
                        indexSelected = 3
                    
                    
                }){
                    HStack {
                        Image(indexSelected == 3 ? "orange video" : "c4" )
                        Text("回忆")
                        .frame(width: 40, height: 20, alignment: .center)
                        .cornerRadius(32)
                        .foregroundColor( grayColor )
                    }
            
                }
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .animation(.easeInOut)
            .background(  LinearGradient(gradient: Gradient(colors: [Color.white, Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)).cornerRadius(15)
                .shadow(color: Color.init("AccentColor"), radius: 3, x: 0.5, y: 1)
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 5, trailing: 15))
                }
            
            ZStack{
             
                    
                        if(indexSelected == 1){
                            ZStack{
                            ScrollView(.vertical, showsIndicators: false){
                                albumUIView(detailImage: $detailImage, detailText: $detailText,isSelected: $isSelected)
                            }
                                if(isSelected){
                                    DetailImageUIView(isSelected: $isSelected, detailImage: $detailImage, detailText: $detailText)
                                }
                        }
                            
                    }
                if(indexSelected == 2){
                    ZStack{
                    ScrollView(.vertical, showsIndicators: false){
                        photosUIView(detailAlbum: $detailAlbum, detailText: $detailText,isSelected1: $isSelected1)
                    }
                        if(isSelected1){
                            DetailAlbumUIView(detailAlbum: $detailAlbum, detailText: $detailText, isSelected1: $isSelected1)
                        }
                }
                }
                if(indexSelected == 3){
//                    Text("123").font(.system(size: 100))
                    ScrollView(.vertical, showsIndicators: false){
                        VideoUIView()
                    }
                           
                }
                
                }
            
        }
    }

    }
}

struct ImageUIView_Previews: PreviewProvider {
    static var previews: some View {
        ImageUIView()
    }
}
