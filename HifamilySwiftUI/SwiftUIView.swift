//
//  SwiftUIView.swift
//  HifamilySwiftUI
//
//  Created by 潘炳名 on 2021/9/18.
//

import SwiftUI

struct SwiftUIView: View {
    @State var context : String = ""
    @State var isChangeInformantion1 = false //用来标识是否更改信息
    @State var memberName1 = "智妍"
    @State var memberIdentity = "女儿"
    @State var memberTelephone = "15025584040"
    var body: some View {
        
        VStack{
            Text("成员名字")
                .font(.callout)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField("个性化语句", text : $context)
            .frame(width:250, height: 50, alignment: .center)
            .foregroundColor(.gray)
            .textFieldStyle(UnderLineTextFieldStyle())
            .keyboardType(.asciiCapableNumberPad)
            .padding(EdgeInsets(top: 0, leading: -10, bottom: 10, trailing: 15))
            
//            .disabled(true)
        }.frame(width: 300)
        .background(Color(white: 0.99))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
        .onTapGesture {
//            self.fold.toggle()
        }
        .frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .topLeading)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
