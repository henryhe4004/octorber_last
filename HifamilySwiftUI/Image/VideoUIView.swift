//
//  VideoUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/22.
//

import SwiftUI

struct VideoUIView: View {
    var body: some View {
        VStack{
            HStack{
                Button(action:{
                    
                }){
                    HStack{
                        Text("一键生成").font(.system(size: 30)).kerning(10)
                            .foregroundColor(Color.white)
                            .padding(EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0))
                        Spacer()
                        Image("right-arrows").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        
                    }
                    .frame(width: 360, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color("AccentColor"))
                    .cornerRadius(15)
                }
            }
            
            HStack{
                Button(action:{
                    
                }){
                    HStack{
                        Text("编辑视频").font(.system(size: 30)).kerning(10)
                            .foregroundColor(Color.white)
                            .padding(EdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 0))
                        Spacer()
                        Image("right-arrows").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
                        
                    }
                    .frame(width: 360, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .background(Color("AccentColor"))
                    .cornerRadius(15)
                }
            }
        }.padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    }
}

struct VideoUIView_Previews: PreviewProvider {
    static var previews: some View {
        VideoUIView()
    }
}
