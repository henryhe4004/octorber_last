//
//  InformUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/22.
//

//这里改了
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

//实时更新个人信息以及把家庭地位改成家庭昵称
class InformationUser: ObservableObject {
    @Published var username = ""
    @Published var phone = ""
    @Published var nickname = ""
    @Published var userId = -1
    @Published var familyPosition = -1//后续讨论是否删除
    @Published var familyName = ""
    @Published var familyStatus = 0
    @Published var isCreater = true
    
    @Published var url = ""
    @Published var MyImage : UIImage = UIImage()
    @Published var treeObjectId = ""
    
    @Published var objectId = LCString("")
}

struct InformUIView: View {
    
    @Environment(\.presentationMode) var presentationModess
    @StateObject var user = InformationUser()
    @ObservedObject var treeData : FamilyTreeData
    @Binding var isLogin:Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId : LCString
    
    @State var isToLogin = false
    @State var isAlert = false
    @State var isPicker = false
    
    @ObservedObject var avatarListModel : AvatarListModel

    
    //不确定是否修改
    @State var rolesArray = Array<String>()
    @State var selectedIndex:Int = 0
 
    
//    @Binding var treeName : String
    @State var isNavigationBarHidden = false
    //不变
    @State var isImage = false
    @State var isLoading = false
    
    var body: some View {
        
        
        GeometryReader { geo in
//        NavigationView {
        VStack {
            //返回按钮
            Button(action: {
                avatarListModel.avatarList.removeAll()
                //修改treeData的值
                let query = LCQuery(className: "_User")
                let _ = query.get(user.objectId) { (result) in
                    switch result {
                    case .success(object: let todo):
//                        let status = (todo.status?.intValue)!
                        let id = (todo.id?.intValue)!
                        let familyTreeId = (todo.familyTreeId?.intValue)!
                        if(familyTreeId == 0){
                            treeData.isHaveTree = false
                            treeData.indexTree = 0
                            treeData.familyIdWrite = 0
                            treeData.familyMemberCountWrite = 1
                            treeData.familyTreeWrite = 0
                            treeData.familyTreeName = ""
                            treeData.treeObjectId = ""
                            
                        }else{
                            let query = LCQuery(className: "familyTree")
                            query.whereKey("familyId", .equalTo(familyTreeId))
                            _ = query.find { result in
                                switch result {
                                case .success(objects: let students):
                                    for item in students{
                                        let createrId = (item.createrId?.intValue)!
                                        if(createrId == id){
                                            treeData.isHaveTree = true
                                        }else{
                                            treeData.isHaveTree = false
                                        }
                                        treeData.indexTree = (item.indexTree?.intValue)!
                                        treeData.familyIdWrite = (item.familyId?.intValue)!
                                        treeData.familyMemberCountWrite = (item.familyNum?.intValue)!
                                        treeData.familyTreeWrite = (item.indexTree?.intValue)!
                                        treeData.familyTreeName = (item.familyName?.stringValue)!
                                        treeData.treeObjectId = (item.objectId?.stringValue)!
                                    }
                                    break
                                case .failure(error: let error):
                                    print(error)
                                }
                                
                                let familyId = familyTreeId
                                if(familyId != 0){
                                    let user = LCQuery(className: "_User")
                                    user.whereKey("familyTreeId", .equalTo(familyId))
                                    user.whereKey("status", .equalTo(1))
                                    _ = user.find { result in
                                        switch result {
                                        case .success(objects: let user):
                                            for item in user{
                                                let avatar = AvatarList(url: (item.url?.stringValue)!, id: (item.id?.intValue)!,username: (item.username?.stringValue)!)
                                                self.avatarListModel.avatarList.append(avatar)
                                            }
                                            avatarListModel.arrayCount = avatarListModel.avatarList.count
                                            break
                                        case .failure(error: let error):
                                            print(error)
                                        }
                                    }
                                    
                                    let InvitationUser = LCQuery(className: "InvitationUser")
                                    InvitationUser.whereKey("treeId", .equalTo(familyId))
                                    InvitationUser.whereKey("status", .equalTo(1))
                                    _ = InvitationUser.find { result in
                                        switch result {
                                        case .success(objects: let user):
                                            for item in user{
                                                let avatar = AvatarList(url: (item.url?.stringValue)!, id: (item.userId?.intValue)!,username: (item.username?.stringValue)!)
                                                self.avatarListModel.avatarList.append(avatar)
                                            }
                                            avatarListModel.arrayCount = avatarListModel.avatarList.count
                                
                                            break
                                        case .failure(error: let error):
                                            print(error)
                                        }
                                    }
                                   
                                }
                            }
                        }
                        
                    
                    case .failure(error: let error):
                        print(error)
                    }
                }
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
                    
                    if(user.url == "father\n" || user.url == "" || user.url == "father"){
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
                        
                        KFImage.url(URL(string:user.url))
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
                    Text(user.username)
                        .font(.title2)
                        .frame(width:geo.size.width - 150, alignment: .leading)
                        .padding(.top,10)
                    HStack {
                        Text( user.isCreater ? "创建者" : "加入者")
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
                            Text("家庭昵称")
                                .padding(.trailing,15)
                            //原来是家庭身份，现在改成家庭昵称
//                            if( rolesArray.count != 0 ){
//                                TextField("请选择您的家庭身份", text: $rolesArray[selectedIndex])
//                            }
//                            else{
//                                TextField("请选择您的家庭身份", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
//                            }
                            
                            TextField("请输入您的家庭昵称", text: $user.nickname,
                            onCommit: {print("修改后的家庭昵称:\(user.nickname)")
                                do {
                                    let todo = LCObject(className: "_User", objectId: user.objectId)
                                    try todo.set("nickname", value: user.nickname)
                                    todo.save { (result) in
                                        switch result {
                                        case .success:
                                            print("修改家庭昵称成功了")
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
                        .onTapGesture {
//                            isPicker = true
                        }
                        
                        if user.isCreater{
                            HStack {
                                Text("家庭树名字")
                                TextField(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/, text: $user.familyName,
                                                                onCommit: {print("修改后的家庭树的名字:\(user.familyName)")
                                    do {
                                        let todo = LCObject(className: "familyTree", objectId: user.objectId)
                                        try todo.set("familyName", value: user.familyName)
                                        todo.save { (result) in
                                            switch result {
                                            case .success:
                                                //应该是传回给了首页
                                                self.treeData.familyTreeName = user.familyName
                                                print("修改名字成功了")
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
                    .frame(width:geo.size.width - 20,height: user.isCreater ? 150 : 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
                    .offset(x: -5)
                    .padding(.bottom,5)
                    
                    Form {
                        HStack {
                            Text("昵称")
                                .padding(.trailing,15)
                            TextField("请输入昵称", text: $user.username,
                                      onCommit: {
                                        print("用户修改后的昵称:\(user.username)")
                                        do {
                                            let todo = LCObject(className: "_User", objectId: user.objectId)
                                            try todo.set("username", value: user.username)
                                            todo.save { (result) in
                                                switch result {
                                                case .success:
                                                    print("修改昵称成功了")
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
//                            if(user.phone == ""){
//                                TextField("请输入手机号", text: $user.phone)
//                            }else{
//                                Text(user.phone)
//                            }
                            TextField("请输入手机号", text: $user.phone,onCommit: {
                                      print("用户修改后的电话号码:\(user.phone)")
                                      do {
                                          let todo = LCObject(className: "_User", objectId: user.objectId)
                                          try todo.set("mobilePhoneNUmber", value: user.phone)
                                          todo.save { (result) in
                                              switch result {
                                              case .success:
                                                  print("修改电话号码成功了")
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
                    .frame(width:geo.size.width - 20,height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .cornerRadius(20)
                    .offset(x: -5)
                    .padding(.bottom,20)
                    
                }
                if(isLoading){
                    LoadingView()
                }
                //是否还需要？？？
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
                            let todo = LCObject(className: "_User", objectId: user.objectId)
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
//                let currentUser = (LCApplication.default.currentUser?.objectId)!
//                user.objectId = currentUser
                isToLogin = true
//                print(currentUser as Any)
                
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
            }else{
                isToLogin = true
                isAlert = true
            }
          
            
            
                    }) {
            logOutView(isLogin: $isLogin, isFirstLogin: $isFirstLogin, isPressed1: $isPressed1, objectId: $user.objectId, isToLogin: $isToLogin, user: user)
                .alert(isPresented: $isAlert, content: {
                    Alert(title:Text("登陆失败"),
                          message: Text("请登陆一个账号"),
                        dismissButton: .default(Text("OK")))
                    
                })

                    }
        
        
            .onAppear(){
                self.user.objectId = (LCApplication.default.currentUser?.objectId)!
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
                
//                获取个人信息
                let objectId = LCApplication.default.currentUser?.objectId
                self.user.objectId = objectId!
                let query = LCQuery(className: "_User")
                let _ = query.get(user.objectId) { (result) in
                    switch result {
                    case .success(object: let todo):
                        if(todo.nickname?.stringValue != nil){
                            self.user.nickname = (todo.nickname?.stringValue)!
                        }
                        let avatar = (todo.url?.stringValue)!
                        self.user.url = avatar
                        let username = (todo.username?.stringValue)!
                        if todo.mobilePhoneNUmber?.stringValue != nil {
                            let mobilePhoneNUmber = (todo.mobilePhoneNUmber?.stringValue)!
                            self.user.phone = mobilePhoneNUmber
                        }
                        //改？？？？？
                            let familyPosition = todo.familyPosition?.intValue
                            self.selectedIndex = familyPosition! - 1

                        let createrId = (todo.id?.intValue)!
                        self.user.username = username
                        let status = (todo.status?.intValue)!
                        self.user.familyStatus = status
                        if status == 1{
                            user.isCreater = true
 
                            let familyTree = LCQuery(className: "familyTree")
                            familyTree.whereKey("createrId", .equalTo(createrId))
                            _ = familyTree.find { result in
                                switch result {
                                case .success(objects: let tree):
                                    for item in tree{
                                    let treeName = (item.familyName?.stringValue!)!
                                        self.user.familyName = treeName
                                        self.user.treeObjectId = (item.objectId?.stringValue!)!
                                        print("家庭树的名字\(user.familyName)")
                                    }
                                    break

                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                        }else{
                            user.isCreater = false
                        }

                    case .failure(error: let error1):
                        print(error1)
                    }
          
                }
               
                
            }

        .sheet(isPresented:$isImage){
            AvatarPicker(MyImage : $user.MyImage,url:$user.url,isLoading:$isLoading)
         }
                
            
        }
        
    }
}





