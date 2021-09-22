//
//  CardUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/16.
//

import SwiftUI

struct CardUIView: View {

    var image: String = "mother" /// 卡片图片名称，供外部传入

    @State var isChangeInformantion = false //用来标识是否更改信息
    @State var memberName = "智妍"
    @State var memberIdentity = "2021/12/1"
    @State var memberTelephone = "15025584040"
    @State private var showingAlert = false
    
    var body: some View {
        
        VStack {
            Image(image)
                .resizable()
                .frame(width:80,height: 80, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .padding()
            
            VStack {
                Text("成员名字")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("请输入成员名字",text:$memberName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isChangeInformantion)
                    .foregroundColor(Color("LandColorAfter"))
                
                Text("成员生日")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("请输入成员生日",text:$memberIdentity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isChangeInformantion)
                    .foregroundColor(Color("LandColorAfter"))
                
                Text("成员电话")
                    .font(.callout)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("请输入成员电话",text:$memberTelephone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disabled(!isChangeInformantion)
                
                }
            .padding(EdgeInsets(top:0,leading:45,bottom:10,trailing: 40))
            
            if(isChangeInformantion){
                Button(action: {
                    self.showingAlert = true
                    self.isChangeInformantion = false
                }) {
                    Text("保存信息")
                }
               
                .padding(EdgeInsets(top:10,leading:45,bottom:30,trailing: 40))
                .buttonStyle(DefaultButtonStyle())
                
            }else{
                Button(action: {
                    self.isChangeInformantion = true
                }) {
                    Text("修改信息")
                        .padding(10)
                        .foregroundColor(.white)
                        .background(Color("AccentColor").cornerRadius(10))
                }
                .alert(isPresented: $showingAlert) {
                            Alert(title: Text("修改信息成功"),
                                  dismissButton: .default(Text("OK")))
                        }
                .padding(EdgeInsets(top:10,leading:45,bottom:30,trailing: 40))
                .buttonStyle(DefaultButtonStyle())
                
            }
            
        }
        .frame(width: 300)
        .background(Color(white: 0.99))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
        .onTapGesture {
//            self.fold.toggle()
        }
        .frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .center)
        
    }
    

}

struct CardUIView_Previews: PreviewProvider {
    static var previews: some View {
        CardUIView()
    }
}

