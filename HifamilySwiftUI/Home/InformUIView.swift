//
//  InformUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/22.
//

import SwiftUI
import LeanCloud
import YPImagePicker
import Kingfisher



struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment

        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

        return path
    }
}


struct InformUIView: View {
    
    @Environment(\.presentationMode) var presentationModess
    @State var isCreater = true;
    @State var username = ""
    @State var phone = ""
    @State var familyPosition = -1
    @State var userId = -1
    @State var familyName = ""
    @State var familyStatus = 0
    
    @Binding var isLogin:Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId : LCString
    
    @State var isToLogin = false
    @State var isAlert = false
    
    @State var isPicker = false
    
    @State var rolesArray = Array<String>()
    @State private var selectedIndex:Int = 0
    @State var treeObjectId = ""
    
    @Binding var treeName : String
    @State var isNavigationBarHidden = false
    @State var MyImage : UIImage = UIImage()
    @State var url : String = ""
    
    @State var isImage = false
    @State var isLoading = false
    var body: some View {
        
        
        GeometryReader { geo in
//        NavigationView {
        VStack {
            //返回按钮
            Button(action: {
                self.presentationModess.wrappedValue.dismiss()//返回的方法
            }) {
                HStack {
                    Image(systemName: "chevron.backward")
                        .frame(width: 20, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("返回")
                        .font(.title3)
                }
                
            }
            .frame(width:geo.size.width, alignment: .leading)
            .padding(.leading,10)
            
            //头像
            HStack {

                ZStack{
                    
                    if(url == "father\n" || url == "" || url == "father"){
                        Image("father")
                                .padding(.leading,30)
                                .shadow(color: Color.gray, radius: 3, x: 5, y: 5)
                    }
                    else{
                    ZStack{
                    Circle()
                        .fill(Color.gray)
                            .frame(width:60,height: 60)
                            .cornerRadius(30)
                            .offset(x: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                            .shadow(color: Color.black, radius: 2, x: 3, y: 3)
                        
                    KFImage.url(URL(string:url))
                        .loadDiskFileSynchronously()
                        .cacheMemoryOnly()
                        .onSuccess { result in  self.isLoading = false}
                        .resizable()
                        .frame(width:80,height: 80)
                        .cornerRadius(40)
                        .padding(.leading,30)
                        .shadow(color: Color.gray, radius: 3, x: 5, y: 5)
                        
                        }
                    
                    
                        
                    }
                    
                }.onTapGesture {
                    isImage = true
                }
                    

                VStack {
                    Text(username)
                        .font(.title2)
                        .frame(width:geo.size.width - 150, alignment: .leading)
                        .padding(.top,10)
                    HStack {
                        Text( isCreater ? "创建者" : "加入者")
                            .frame(width: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .font(.subheadline)
                            .foregroundColor(Color("AccentColor"))
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(13)
                            .shadow(color: Color("AccentColor"), radius: 3, x: 3, y: 3.0)

                            
                    }
                    .frame(width:geo.size.width - 150, alignment: .leading)
                }
                .padding(.leading,20)
                
               
            }
            .frame(width:geo.size.width, height:100, alignment: .leading)
            .padding(.bottom,20)
            
            
            ZStack {
                
               
                VStack {
                    Form{
                        HStack {
                            Text("家庭身份")
                                .padding(.trailing,15)
                            if( rolesArray.count != 0 ){
                                TextField("请选择您的家庭身份", text: $rolesArray[selectedIndex])
                            }
                            else{
                                TextField("请选择您的家庭身份", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                            }
                            
                        
                        }
                        .onTapGesture {
                            isPicker = true
                        }
                        
                        if isCreater{
                            HStack {
                                Text("家庭树名字")
                                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $familyName,
                                onCommit: {print("修改后的家庭树的名字:\(familyName)")
                                    do {
                                        let todo = LCObject(className: "familyTree", objectId: treeObjectId)
                                        try todo.set("familyName", value: familyName)
                                        todo.save { (result) in
                                            switch result {
                                            case .success:
                                                self.treeName = familyName
                                                print("修改名字成功了")
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        }
                                        _ = todo.fetch { result in
                                            switch result {
                                            case .success:
                                                // todo 已刷新
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        }
                                    } catch {
                                        print(error)
                                    }
                                    
                                })
                            }
                        }
                       
                       
                    }
                    .frame(width:geo.size.width - 20,height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
                    .offset(x: -5)
                    .padding(.bottom,5)
                    
                    Form {
                        HStack {
                            Text("昵称")
                                .padding(.trailing,15)
                            TextField("请输入昵称", text: $username,
                                      onCommit: {
                                        print("用户修改后的昵称:\(username)")
                                        do {
                                            let todo = LCObject(className: "_User", objectId: objectId)
                                            try todo.set("username", value: username)
                                            todo.save { (result) in
                                                switch result {
                                                case .success:
                                                    print("修改昵称成功了")
                                                    break
                                                case .failure(error: let error):
                                                    print(error)
                                                }
                                            }
                                            _ = todo.fetch { result in
                                                switch result {
                                                case .success:
                                                    // todo 已刷新
                                                    break
                                                case .failure(error: let error):
                                                    print(error)
                                                }
                                            }
                                        } catch {
                                            print(error)
                                        }
                                      })
                            
                        }
                        HStack {
                            Text("手机号")
                            if(phone == ""){
                                TextField("请输入手机号", text: $phone)
                            }else{
                                Text(phone)
                            }
                            
                        }
                        
                        
                    }
                    .frame(width:geo.size.width - 20,height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
                    .offset(x: -5)
                    .padding(.bottom,20)
                    
                }
                if(isLoading){
                    LoadingView()
                }
                if(isPicker){

                    Picker(selection: $selectedIndex, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/) {
                        ForEach(rolesArray.indices, id: \.self) { item in
                        
                                           HStack {
                                               Image(systemName: "\(item+1).circle.fill")
                                                .foregroundColor(Color("AccentColor"))
                                               Text(rolesArray[item])
                                                .foregroundColor(Color("AccentColor"))
                                           }
                                         
                                       }
                    }
                    .offset(x:-5,y:20)
                    .frame(width: 300)
                    .background(Color.white)
                    .cornerRadius(30)
                    .padding()
                    .shadow(color: Color("AccentColor"), radius: 3, x: 2, y: 2.0)
                    .onTapGesture {
                        isPicker = false
                        do {
                            let todo = LCObject(className: "_User", objectId: objectId)
                            try todo.set("familyPosition", value: selectedIndex + 1)
                            todo.save { (result) in
                                switch result {
                                case .success:
                                    print("修改身份成功\(selectedIndex)")
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                        } catch {
                            print(error)
                        }
                    }
                    
                    
                }
            }
            Button(action: {
                LCUser.logOut()
                let currentUser = LCApplication.default.currentUser
                isToLogin = true
                print(currentUser as Any)
                
            }) {
                Text("退出当前账号")
                    .font(.headline)
                    .frame(width:UIScreen.main.bounds.width - 90*2,height:56)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(30)
            }
            Spacer()
            }
        
        .sheet(isPresented: $isToLogin, onDismiss: {
            if(isLogin == true){
                isToLogin = false
            }
                isAlert = true
                    }) {
            LoginUIView(isLogin: $isLogin, isFirstLogin: $isFirstLogin, isPressed1: $isPressed1, objectId: $objectId)

                    }
        .alert(isPresented: $isAlert, content: {
            Alert(title: Text(isLogin ? "登陆成功":"出错了"),
                  message: Text(isLogin ? "开启您的家庭之旅":"请先登录账号"),
            dismissButton: .default(Text("OK"),
                                    action: {
                                        if(isLogin == false){
                                            isToLogin = true
                                        }
                                    }))
            
        })
        
            .onAppear(){
                //获取家庭成员关身份
                        let familyMember = LCQuery(className: "FamilyMember")
                        _ = familyMember.find { result in
                            switch result {
                            case .success(objects: let member):
                                print(member)
                                for item in member{
                                    if(item.id?.intValue != 0){
                                    let str1 = item.familyMember?.stringValue
                                    self.rolesArray.append(str1!)
                                    }
                                }
                                
                                break
                            case .failure(error: let error):
                                print(error)
                            }
                        }
                
                //获取个人信息
                let objectId = LCApplication.default.currentUser?.objectId
                self.objectId = objectId!
                let query = LCQuery(className: "_User")
                let _ = query.get(objectId!) { (result) in
                    switch result {
                    case .success(object: let todo):
                        let avatar = todo.url?.stringValue
                        self.url = avatar!
                        let username = todo.username?.stringValue
                        if todo.mobilePhoneNUmber?.stringValue != nil {
                            let mobilePhoneNUmber = todo.mobilePhoneNUmber?.stringValue
                            self.phone = mobilePhoneNUmber!
                        }
                        if todo.familyPosition?.intValue != nil {
                            let familyPosition = todo.familyPosition?.intValue
                            self.familyPosition = familyPosition!
                            self.selectedIndex = familyPosition!
                        }
                        let createrId = todo.id?.intValue
                        self.username = username!
                        let status = todo.status?.intValue
                        self.familyStatus = status!
                        if status == 1{
                            
                            let familyTree = LCQuery(className: "familyTree")
                            familyTree.whereKey("createrId", .equalTo(createrId!))
                            _ = familyTree.find { result in
                                switch result {
                                case .success(objects: let tree):
                                    for item in tree{
                                    let treeName = item.familyName?.stringValue!
                                    self.familyName = treeName!
                                    self.treeObjectId = (item.objectId?.stringValue!)!
                                    print("家庭树的名字\(familyName)")
                                    }
                                    break
                                        
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                        }

                    case .failure(error: let error1):
                        print(error1)
                    }
          
                }
               
                
            }

        .sheet(isPresented:$isImage){
            AvatarPicker(MyImage : $MyImage,url:$url,isLoading:$isLoading)
         }
                
            
        }
        
    }
}



//struct InformUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        InformUIView(isLogin: <#Binding<Bool>#>, isFirstLogin: <#Binding<LCBool>#>, isPressed1: <#Binding<Bool>#>, objectId: <#Binding<LCString>#>)
//    }
//}

