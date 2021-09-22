//
//  WriteLetterVeiw.swift
//  HifamilySwiftUI
//
//  Created by 吴柏辉 on 2021/9/17.
//

import SwiftUI

final class Letters: ObservableObject {
    @Published  var letter:String
    @Published var recipient:String
    @Published var sender:String
    init() {
        letter = ""
        recipient = ""
        sender = ""
    }
}

struct WriteLetterView: View {
    
    @ObservedObject var letterr:Letters = Letters()
    var body: some View {
        
        VStack {
//            UpperLine()
            Divider()
            VStack{
                VStack {
                    HStack {
                        Text("收件人:")
                            .foregroundColor(Color(UIColor(red: 0.38, green: 0.38, blue: 0.38,alpha:1)))
                            .font(.system(size: 20))
    //                    Text("Your letter is \(letterr.letter)!")
                        TextField(
                            "输入",
                            text: $letterr.recipient
                        ) {isEditing in
                            self.letterr.recipient = letterr.recipient
                        }.font(.system(size: 20))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                        .keyboardType(.default)
                        
                    }.padding(EdgeInsets(top: 28, leading: 33, bottom: 0, trailing: 20))
                    Divider()
                        .frame(width:323 ,height: 1 ,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                }
                
                VStack {
                    TextField("在这输入你的家书内容~", text: $letterr.letter){
                        isEditing in
                        self.letterr.letter = letterr.letter
                    }.frame(width: 323, height: 200,alignment: .topLeading)
                    
                    
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                VStack {
                    HStack {
                        Text("寄信人:")
                            .foregroundColor(Color(UIColor(red: 0.38, green: 0.38, blue: 0.38,alpha:1)))
                            .font(.system(size: 20))
    //                    Text("Your letter is \(letterr.letter)!")
                        TextField(
                            "输入",
                            text: $letterr.sender
                        ) {isEditing in
                            self.letterr.sender = letterr.sender
                        }.font(.system(size: 20))
//                        .autocapitalization(.none)
//                        .disableAutocorrection(true)
//                        .keyboardType(.default)
                        
                    }.padding(EdgeInsets(top: 28, leading: 33, bottom: 0, trailing: 20))
                    Divider()
                        .frame(width:323 ,height: 1 ,alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding(EdgeInsets(top: -1, leading: 0, bottom: 0, trailing: 0))
                }
                
                
                VStack {
                    Image("family-letter")
                        .padding(EdgeInsets(top: 14, leading: -110, bottom: 0, trailing: 0))
                }
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .frame(width: 58, height: 29, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundColor(orangeColor)
                        Text("公开")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .frame(width: 58, height: 29, alignment: .center)
                            .foregroundColor(Color(UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1)))
                        Text("私密")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }.padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                }.padding(EdgeInsets(top: 20, leading: 270, bottom: 0, trailing:0))
            }.navigationBarTitle(Text("写家书").foregroundColor(grayColor2)
                .font(.system(size: 22)),displayMode: .inline)
            .navigationBarItems(trailing: Button(action:{} ){
                Text("寄出")
                    .foregroundColor(orangeColor)
//                    .font(.system(size: 22))
            })
            
            Spacer()
        }
}

struct WriteLetterView_Previews: PreviewProvider {
    static var previews: some View {
        WriteLetterView()
    }
}

struct UpperLine: View {
    var body: some View {
        HStack {
            Image("Iconly-Bulk-Setting")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
            Spacer()
            Text("写家书")
                .foregroundColor(grayColor2)
                .font(.system(size: 22))
            Spacer()
            Text("寄出")
                .foregroundColor(orangeColor)
                .font(.system(size: 22))
        }.padding()
    }
}
}
