//
//  AddMemberCardUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/17.
//

import SwiftUI

struct AddMemberCardUIView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: MemberModel.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \MemberModel.familyId, ascending: true)])
    var memberModels: FetchedResults<MemberModel>
    
    @State private var showingFrame = false
    
    @State var memberName = ""
    @State var memberIdentity = ""
    @State var memberTelephone = ""
    @State private var showingAlert = false
    @State private var defaultAvatar = "mother"
    
    
    var body: some View {
        
        VStack {
            Text( showingFrame ? "填写成员信息" : "点击添加家庭成员")
                .font(.title2)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(Color("LandColorAfter"))
            Image(showingFrame ? defaultAvatar : "addMember")
                .resizable()
                .frame(width:showingFrame ? 70 : 100,height: showingFrame ? 70 : 100, alignment: .center)
                .aspectRatio(contentMode: .fit)
               
                .onTapGesture {
                    self.showingFrame = true
                }
            if(showingFrame){
                VStack {
                    Text("成员名字")
                        .font(.callout)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("请输入成员名字",text:$memberName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        .foregroundColor(Color("LandColorAfter"))
                    
                    Text("成员生日")
                        .font(.callout)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("请输入成员生日",text:$memberIdentity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        .foregroundColor(Color("LandColorAfter"))
                    
                    Text("成员电话")
                        .font(.callout)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("请输入成员电话",text:$memberTelephone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                       showingAlert = true
                        
                        //给数据库写入数据
                        let memberModel = MemberModel(context: self.viewContext)
                         memberModel.name = memberName
                         memberModel.avatar = defaultAvatar
                         memberModel.birthday = memberIdentity
                         memberModel.phone = memberTelephone
                        try? self.viewContext.save()
                        
                        
                    }) {
                        Text("发送邀请")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color("AccentColor").cornerRadius(10))
                    }
                    .padding(10)
                    .alert(isPresented: $showingAlert) {
                                Alert(title: Text("邀请成员成功，等待对方确认"),
                                      dismissButton: .default(Text("OK"),
                                    action: {self.showingFrame = false}
                                      )
                                )
                            }
                    
                    }
                .padding(EdgeInsets(top:0,leading:45,bottom:20,trailing: 40))

            }
          
        }
        .frame(width: 280,height: 440)
        .background(Color(white: 0.99))
        .cornerRadius(10)
        .shadow(color: .gray, radius: 10, x: 0, y: 3)
        .animation(.easeInOut)
        .onTapGesture {
//            self.fold.toggle()
        }
        .frame(minWidth: 0/*@END_MENU_TOKEN@*/,  maxWidth: .infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0,  maxHeight: /*@START_MENU_TOKEN@*/.infinity, alignment: .center)
        .offset(x: 0, y: 16.0)
    }
    
}

struct AddMemberCardUIView_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberCardUIView()
    }
}

