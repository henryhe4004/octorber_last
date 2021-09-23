//
//  DetailLetterView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/23.
//

import SwiftUI

struct DetailLetterView: View {
    @Binding
//    @State
    var name : String
//        = "我的妍大宝"
    @Binding
//    @State
    var content : String
//        = "多吃点，不要减肥，晚上 不要出门，要学会照顾自 己，常回家看看，给你做 你爱吃的红烧带鱼~🤗"
    @Binding
//    @State
    var yourName : String
//        = "爱你的妈妈"
    @Binding
//    @State
    var date : String
//        = "2021.07.05"
    @Binding
//    @State
      var isLetterSelected : Bool
    
    @Binding
    
    var namefirst : String
    
    @Binding
    
    var nameSecond : String
    
//        = false
    var body: some View {
        ZStack{
            Rectangle().fill(Color.gray).opacity(0.5)
            ScrollView(.vertical, showsIndicators: false){
                Image(systemName: "arrowshape.turn.up.left.fill")
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(Color("AccentColor"))
                    .onTapGesture {
                        isLetterSelected = false
                    }
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .offset(x: -130, y: 0)
                VStack{
                    HStack{
                        Image("family-letter").padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 0))
                        Spacer()
                    }
                    HStack{
                        Text(name)
                            .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                            .font(.system(size: 23))
                        Spacer()
                    }.padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
                    HStack{
                        Text(content)
                            .foregroundColor(Color.init(UIColor(red: 0.45, green: 0.45, blue: 0.45,alpha:1)))
                            .font(.system(size: 20))
                            .lineSpacing(12.0)
                    }.padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
                    
                    HStack{
                        Spacer()
                        Text(yourName)
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 15, trailing: 20))
                            .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                            .font(.system(size: 20))
                            
                    }
                    VStack{
                        HStack{
                            Text("收件人: \(namefirst)").padding(EdgeInsets(top: 0, leading: 15, bottom: 2, trailing: 15))
                                .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                                .font(.system(size: 20))
                            Spacer()
                        }
                        HStack{
                            Text("发件人: \(nameSecond)")
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 5, trailing: 15))
                                .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                                .font(.system(size: 20))
                            Spacer()
                        }
                        HStack{
                            Text("上传时间: \(date)")
                                .padding(EdgeInsets(top: 0, leading: 15, bottom: 20, trailing: 15))
                                .foregroundColor(Color(red: 97/255, green: 97/255, blue: 97/255))
                                .font(.system(size: 20))
                            Spacer()
                        }
                    }
                } .frame(width: 300)
                .background(Color(white: 0.99))
                .overlay(RoundedRectangle(cornerRadius: 20.0, style: .continuous).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 10, x: 0, y: 3)
                .animation(.easeInOut)
            }.frame(width: 300, height: 600, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        }
    }

//struct DetailLetterView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailLetterView()
//    }
//}
