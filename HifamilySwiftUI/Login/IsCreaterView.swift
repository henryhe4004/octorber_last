//
//  IsCreaterView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/17.
//

import SwiftUI
import LeanCloud
struct IsCreaterView: View {
    
    @Binding var objectId:LCString
    @State var status:Int = 0
    @State var isLoginBefore = false
    @Binding var isPressed : Bool
    @State var error1 = false
    @State var error2 = false
    @Binding var isLogin : Bool
    @State var error3 : String = ""
    
    var body: some View {
        GeometryReader { geo in
        ZStack {
            Image("family")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Button(action: {
                    
                    
                    //用自己的userId执行创建一个家庭树，并赋值会给user
                    //获取自己的user ID
                    let objectId = (LCApplication.default.currentUser?.objectId)!
                    let query = LCQuery(className: "_User")
                    let _ = query.get(objectId) { (result) in
                        switch result {
                        case .success(object: let todo):
                            //获取到自己的userId
                            let userId = (todo.id?.intValue)!
                            //建立一个家庭树
                            do {
                                // 构建对象
                                let tree = LCObject(className: "familyTree")
                                // 为属性赋值
                                try tree.set("createrId", value: userId)
                                // 将对象保存到云端
                                _ = tree.save { result in
                                    switch result {
                                    case .success:
                                        //找到tree ID
                                        let query = LCQuery(className: "familyTree")
                                        query.whereKey("createrId", .equalTo(userId))
                                        _ = query.find { result in
                                            switch result {
                                            case .success(objects: let students):
                                                for item in students{
                                                    let treeId = (item.familyId?.intValue)!
                                                    //把treeID返回到_user
                                                        do {
                                                            let user = LCObject(className: "_User", objectId: objectId)
                                                            try user.set("familyTreeId", value: treeId)
                                                            user.save { (result) in
                                                                switch result {
                                                                case .success:
                                                                    break
                                                                case .failure(error: let error):
                                                                    print(error)
                                                                }
                                                            }
                                                        } catch {
                                                            print(error)
                                                        }
                                                    
                                                }
                                                        
                                                break
                                            case .failure(error: let error):
                                                print(error)
                                            }
                                        }
                                        break
                                    case .failure(error: let error):
                                        // 异常处理
                                        print(error)
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        
                       
                            
                            
                        case .failure(error: let error):
                            print(error)
                        }
                    }
                    status = 1
                    isLoginBefore = true
                    isPressed = false
                    isLogin = true
                    error2 = updateUser(objectId1: objectId, status1: status)
                }) {
                    HStack {
                        Text("创建者")
                            .font(.title2)
                        Spacer()
                        Image("right-arrows")
                    }
                    .padding()
                    
                }
                .alert(isPresented: $error2, content: {
                    Alert(title: Text("Hello SwiftUI!"),
                                      message: Text("出错了"),
                                      dismissButton: .default(Text("OK")))
                })
                .frame(width: 308, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(red: 0.952, green: 0.523, blue: 0.008))
                .foregroundColor(.white)
                .cornerRadius(21)
                
                Button(action: {
                    status = 0
                    isPressed = false
                    isLogin = true
                    error2 = updateUser(objectId1: objectId, status1: status)
                }) {
                    HStack {
                        Text("加入者")
                            .font(.title2)
                        Spacer()
                        Image("right-arrows")
                    }
                    .padding()
                }
                .frame(width: 308, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .background(Color(red: 0.939, green: 0.635, blue: 0.201))
                .foregroundColor(.white)
                .cornerRadius(21)
                .alert(isPresented: $error2, content: {
    //                if(errorCode==1)
    //                {Alert(title: Text("出错了"),
    //                                  message: Text("手机号登陆出错"),
    //                                  dismissButton: .default(Text("OK")))
    //                }
    //                if(errorCode==2){
    //                Alert(title: Text("Hello SwiftUI!"),
    //                                  message: Text("注册用户失败"),
    //                                  dismissButton: .default(Text("OK")))
    //                }
              
                    Alert(title: Text("error!"),
                          message: Text("\(error3)"),
                                      dismissButton: .default(Text("OK")))
                    
                    
                })
                Spacer()
            }
            .frame(width: geo.size.width, height: 2*geo.size.height/3, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(.top,20)
            
        }
        .frame(width:geo.size.width - 20)
        }
        
    }
    func updateUser(objectId1:LCString,status1:Int) -> Bool {
        do {
            let todo = LCObject(className: "_User", objectId: objectId1)
            try todo.set("isFirstLogin", value: false)
            try todo.set("status",value: status1)
            todo.save { (result) in
                switch result {
                case .success:
                   
                    break
                case .failure(error: let error):
                    error1 = true
                    error3 = error.reason!
                    print(error)
                }
            }
        } catch {
            print(error)
            error1 = true
            return false
        }
        if (error1 == true){
            return true
        }else{
            return false
        }
    }
}

