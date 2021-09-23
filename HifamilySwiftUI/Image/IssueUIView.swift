//
//  IssueUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/19.
//

import SwiftUI

struct IssueUIView: View {
    @State var people : String = "妍妍"
    @State var content : String = ""
    @State var isPresented : Bool = false
    @State var isIssue : Bool = false
    var items : [GridItem] = [
        GridItem(GridItem.Size.flexible(),spacing: 0),
        GridItem(GridItem.Size.flexible(),spacing: 0)
    ]
    
    var body: some View {
        VStack{
            Divider()
            ScrollView(){
                VStack {
                    HStack{
                        Text("时光记录人: \(people)").font(.system(size: 25))
                            .foregroundColor(Color(red: 115/255, green: 115/255, blue: 115/255))
                            .padding(EdgeInsets(top: 30, leading: 20, bottom: 30, trailing: 0))
                        
                        Spacer()
                    }
                    
                }
                
                VStack{
                    HStack{
                        Text("用文字记录美好:")
                            .foregroundColor(grayColor)
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 5, trailing: 30))
                        Spacer()
                    }
                    KeyboardHost{
                        TextView(
                            text: $content
                        )
                        .frame(width:350,height: 300, alignment: .topLeading)
                        
                        .foregroundColor(grayColor2)
                        .keyboardType(.default)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .multilineTextAlignment(.leading)
                        .ignoresSafeArea(.keyboard)
                        .overlay(RoundedRectangle(cornerRadius: 10.0, style: .continuous).stroke(Color.init(red: 255/255, green: 169/255, blue: 54/255),lineWidth: 1.4)).shadow(radius: 1)
                    }
                }
                VStack{
                LazyVGrid(columns: items, content: {
                    ForEach(1..<3){ index in
                        Image("littleYou\(index)")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 170, height: 170, alignment: .center)
                            .cornerRadius(20)
                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                    }
                    
                    
                    Button(action:{
                        self.isPresented = true
                    }){
                        Image("ic_add_a_photo_48px")
                            .resizable()
                            .frame(width: 100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center)
                    }
                    .frame(width: 170, height: 170, alignment: .center)
                    .cornerRadius(20)
                    .background(Color(red: 245/255, green: 245/255, blue: 245/255)).cornerRadius(20)
                    .fullScreenCover(isPresented: $isPresented, content: {
                        ImagePickerView()
                    })
                }
                )
                }.frame(width:360)
            }
            
//            TextField
        }.navigationBarTitle(Text("新照片"),displayMode: .inline)
        .navigationBarItems(trailing: Button(action:{
            self.isIssue.toggle()
        })
            {
            Text("发布").foregroundColor(Color("AccentColor"))
            } .alert(isPresented: $isIssue, content: {
                Alert(title: Text("上传成功"))
            })
        )
    }
}

struct IssueUIView_Previews: PreviewProvider {
    static var previews: some View {
        IssueUIView()
    }
}
