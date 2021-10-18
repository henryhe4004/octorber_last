//
//  LoginUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/6.
//

import SwiftUI
import LeanCloud


struct LoginUIView: View {
    
    @State var pageType = "signin"
    @State var isAnimating = false
    @State var username = ""
    @State var password = ""
    
    @State var isShowLoading = false
    @State var isShowAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""

    @Binding var isLogin:Bool
    @Binding var isFirstLogin:LCBool
    @Binding var isPressed1:Bool
    @Binding var objectId:LCString


    var body: some View {
        
        ZStack {
            
            VStack(alignment:.leading){
                
                TopTitleView(pageType: $pageType)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.spring().delay(0))
                
                SlideMenuView(pageType: $pageType)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.spring().delay(0.2))
                
                FormView(username: $username, password: $password, pageType: $pageType)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.spring().delay(0.4))
                
                LoginView(pageType: $pageType, username: $username, password: $password, isShowLoading: $isShowLoading,isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.spring().delay(0.6))
                    .debugPrint(("2\(isPressed1)"))
                    
                    
                
                
                Spacer()
                

                
            }
            .padding(.leading,40)
            .padding(.trailing,40)
            .onAppear{
                self.isAnimating.toggle()
            }
            

            
            if isShowLoading {
                LoadingView()
            }
        }
            
}
}




struct TopTitleView: View {
    @Binding var pageType : String
    var body: some View {
        HStack(alignment:.top){
            Image("welcome")
                .resizable()
                .frame(width: 140, height: 75, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer()
        }
        .padding(.top,20)
    }
}

struct SlideMenuView: View {
    @Binding var pageType : String
    var body: some View {
        VStack(alignment:.leading){
            HStack{
                Button(action: {
                        withAnimation{
                    self.pageType = "signin"
                }}) {
                    Text("登陆")
                        .foregroundColor(pageType == "signin" ? .orange : .gray)
                        .font(.system(size:20))
                }
                Button(action: {withAnimation{
                    self.pageType = "signup"
                }}) {
                    HStack{
                        Text("注册")
                            .padding(.leading,20)
                            .foregroundColor(pageType == "signup" ? .orange : .gray)
                            .font(.system(size:20))

                    }
                }
            }
            
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.orange)
                .frame(width:30,height:4)
                .offset(x:pageType == "signin" ? 5 : 75,y:0)
                .animation(.spring())
        }
        .padding(.top,20)
        
    }
}

struct FormView: View {
    private let distance : CGFloat = 40
    @Binding var username : String
    @Binding var password : String

    
    @Binding var pageType : String
//    @ObservedObject var user:User
    @State var isDisplayPassword = true
    @State var passwordAgain = ""
    
    var body: some View {
        VStack(alignment:.leading){
            Text("手机号")
            HStack{
                TextField("请输入您的手机号",text:$username)
            }
            
            Rectangle()
                .fill(Color("LoginLine"))
                .frame(width: UIScreen.main.bounds.width - distance*2, height: 1)
            
            Text("密码")
                .padding(.top,20)
            HStack{
                if(isDisplayPassword){
                    SecureField("请输入您的密码",text:$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }else{
                    TextField("请输入您的密码",text:$password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Image(systemName: isDisplayPassword ? "eye.slash":"eye")
                    .foregroundColor(isDisplayPassword ? .gray : .orange)
                    .onTapGesture {
                        self.isDisplayPassword.toggle()
                    }
            }
            
            Rectangle()
                .fill(Color("LoginLine"))
                .frame(width: UIScreen.main.bounds.width - distance*2, height: 1)
            if pageType == "signup"
            {
                
                Text("确认密码")
                    .padding(.top,20)
                HStack{
                    if(isDisplayPassword){
                        SecureField("请再次输入您的密码",text:$passwordAgain)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }else{
                        TextField("请再次输入您的密码",text:$passwordAgain)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    if(passwordAgain != password){
                        
                    }
                    
                    Image(systemName: isDisplayPassword ? "eye.slash":"eye")
                        .foregroundColor(isDisplayPassword ? .gray : .orange)
                        .onTapGesture {
                            self.isDisplayPassword.toggle()
                        }
                }
                Rectangle()
                    .fill(Color("LoginLine"))
                    .frame(width: UIScreen.main.bounds.width - distance*2, height: 1)
                
            }
        }
        .padding(.top,30)
    }
   
}

struct LoginView: View {
    @Binding var pageType : String
    @Binding var username : String
    @Binding var password : String
    @Binding var isShowLoading:Bool
    @Binding var isLogin : Bool
    
    @State var errorReason :String = ""
    
    @State var isLoginError = false
    
//    @State var isRegistError = true
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId : LCString
    var body: some View {
        VStack{
            Text("忘记密码?")
                .bold()
                .font(.system(size:12))
                .foregroundColor(.gray)
                .padding(.bottom,10)
                .padding(.leading, UIScreen.main.bounds.width/2+59)
            Button(action: {
                if pageType == "signup"{
                    isShowLoading = true
                    if username.count == 11{
                        
                    }
                    let user = LCUser()
                    user.username = LCString(username)
                    user.password = LCString(password)
                    
                    _ = LCSMSClient.requestShortMessage(mobilePhoneNumber: "\(username)", templateName: "template_name", signatureName: "sign_name") { (result) in
                        switch result {
                        case .success:
                            isShowLoading = false
                            break
                        case .failure(error: let error):
                            
                            errorReason = error.reason!;
                            isLoginError = true;
                            isShowLoading = false
                            print(error)
                        }
                    }
                    
                    _ = user.signUp { (result) in
                        
                        switch result {
                        case .success:
                            isShowLoading = false
                            print("注册成功")
                            break
                        case .failure(error: let error):
                            errorReason = error.reason!;
                            isLoginError = true
                            isShowLoading = false
                             print("注册失败，失败原因：\(error)")
                             
                        }
                    
                }
                }
                if pageType == "signin"{
                    _ = LCUser.logIn(username: username, password: password) { result in
                        switch result {
                        case .success(object: let user):
                            isFirstLogin = user.isFirstLogin as! LCBool
                            if(isFirstLogin == true){
                                isPressed1 = true
                            }else{
                                isLogin = true
                            }
                            objectId = user.objectId!
                            isShowLoading = false
                            print("1\(isPressed1)")
                            print(user)
                        
                        case .failure(error: let error):
                            errorReason = error.reason!;
                            isLoginError = true
                            isShowLoading = false
                            print("登陆失败原因\(error)")
                        
                    }
                }
                
                }
            }) {
                HStack{
                    Text(pageType == "signin" ? "登录":"确认注册")
                        .bold()
                        .font(.system(size:22))
                }
            }
            .frame(width:UIScreen.main.bounds.width - 40*2,height:56)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(30)
            .padding(.top,30)
            
            .alert(isPresented: $isLoginError, content: {
                Alert(title: Text("出错了"),
//                                  message: Text("\(errorReason)"),
                                    message: Text(pageType == "signin" ? "登录失败":"注册失败"),
                                  dismissButton: .default(Text("OK")))
                
            })
            .fullScreenCover(isPresented: $isPressed1, onDismiss: {
                            print("3\(isPressed1)")
                        }) {
                            IsCreaterView(objectId: $objectId,isLogin: $isLogin)
                        }
            
            
            VStack{
                
                ZStack{
                    Rectangle()
                        .fill(Color("LoginLine"))
                        .frame(width:280,height:1)
                    Text("其他方式登陆")
                        .frame(width:140,height:20)
                        .background(Color.white)
                        .foregroundColor(.gray)
                }
                HStack(spacing:30){
                    ZStack{
                        Image("ios")
                    }
                    .frame(width:50,height:50)
                    .background(Color.orange)
                    .cornerRadius(25)
                    ZStack{
                        Image("QQ")
                    }
                    .frame(width:50,height:50)
                    .background(Color("Reminder"))
                    .cornerRadius(25)
                    ZStack{
                        Image("wechat")
                    }
                    .frame(width:50,height:50)
                    .background(Color("Reminder"))
                    .cornerRadius(25)
                    
                }
                .padding(.top,20)
            }
            .padding(.top,60)
        }
        .padding(.top,15)
    }
}
