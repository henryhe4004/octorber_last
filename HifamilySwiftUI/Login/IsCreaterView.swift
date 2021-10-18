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
    @State var isPressed = false
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
                    status = 1
                    isLoginBefore = true
                    isPressed = true
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
                    isPressed = true
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

