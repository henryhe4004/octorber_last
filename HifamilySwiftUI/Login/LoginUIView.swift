//
//  LoginUIView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/10/6.
//

import SwiftUI
import LeanCloud

final class User : ObservableObject {
    @Published var objectId : String
    @Published var familyPosition : Int
    @Published var familyTreeId : Int
    @Published var id : Int
    @Published var isFirstLogin : Bool
    @Published var missNum : Int
    @Published var status : Int
    @Published var username : String
    init(){
        objectId = ""
        familyPosition = 0
        familyTreeId = 0
        id = 0
        isFirstLogin = true
        missNum = 0
        status = 0
        username = ""
    }
}

//验证手机号
func isPhoneNumber(phoneNumber:String) -> Bool {
       if phoneNumber.count == 0 {
           return false
       }
       let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
       let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
       if regexMobile.evaluate(with: phoneNumber) == true {
           return true
       }else
       {
           return false
       }
   }
//密码正则  6-8位字母和数字组合
func isPasswordRuler(password:String) -> Bool {
      let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
      let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
      if regexPassword.evaluate(with: password) == true {
          return true
      }else
      {
          return false
      }
  }

//struct entity_user{
//    var username : String
//    var password : String
//    var againPassword: String
//
//    init() {
//        username = ""
//        password = ""
//        againPassword = ""
//    }
//
//}
struct LoginUIView: View {
//    @State var user1 : entity_user
    @State var pageType = "signin"
    @State var isAnimating = false
@State var username = ""
    @State var password = ""
    @State var againPassword = ""
    
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
                
                FormView(username: $username, password: $password,againPassword: $againPassword, pageType: $pageType)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(Animation.spring().delay(0.4))
                
                LoginView(pageType: $pageType, username: $username, password: $password, isShowLoading: $isShowLoading,isLogin: $isLogin, againPassword: $againPassword,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId)
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
    @Binding var againPassword : String
    
    @Binding var pageType : String
//    @ObservedObject var user:User
    @State var isDisplayPassword = true
//    @State var passwordAgain = ""
    @State var isNameFocused = false
    @State var isPhoneAlert = false
    @State var isPassFocused = false
    @State var isPassAgainFocused = false
    @State var alertReason = ""
    
    @State var isPassFocused2 = 0
    var body: some View {
        VStack(alignment:.leading){
            Text("手机号")
            HStack{
                TextField("请输入您的手机号",text:$username, onEditingChanged: { (isNameFocused) in
                    if pageType == "signup"{
                        if isNameFocused {
                            print("TextField focused")
                        } else {
                            print("TextField focus removed")
                          if isPhoneNumber(phoneNumber: username){
                              print("输入的是手机号")
                          }else{
                            alertReason = "请输入正确的手机号"
                            isPhoneAlert = true
                          }
                        }
                    }
                                   
                                  }
                )
                    .keyboardType(.namePhonePad)

            }
            
            
            Rectangle()
                .fill(Color("LoginLine"))
                .frame(width: UIScreen.main.bounds.width - distance*2, height: 1)
            
            Text("密码")
                .padding(.top,20)
            HStack{
                if(isDisplayPassword){
                    //没想到解决方案！！！！
                    SecureField("请输入您的密码",text:$password)


                }else{
                    TextField("请输入您的密码",text:$password)

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
                    //没想到解决方案！！！！
                    if(isDisplayPassword){
                        SecureField("请再次输入您的密码",text:$againPassword)

                    }else{
                        TextField("请再次输入您的密码",text:$againPassword

                        )

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
        .padding(.top,20)
        .alert(isPresented: $isPhoneAlert, content: {
            Alert(title:Text("错误！！！"),
                  message: Text("\(alertReason)"),
                dismissButton: .default(Text("OK")))
            
        })
    }
    
   
}

struct LoginView: View {
    @Binding var pageType : String
    @Binding var username : String
    @Binding var password : String
    @Binding var isShowLoading:Bool
    @Binding var isLogin : Bool
    @Binding var againPassword : String
    
    @State var errorReason :String = ""
    @State var successReason:String = ""
    @State var isLoginError = false
    @State var isLoginTrue = false
    
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
                    if(!isPasswordRuler(password:password) || password != againPassword){
                        isShowLoading = false
                        errorReason = password == againPassword ? "请输入6-8位字母和数字组合的密码":"两次密码输入不一样"
                        isLoginError = true
                    }
                    if isPasswordRuler(password:password) && password == againPassword{
                        let user = LCUser()
                        user.username = LCString(username)
                        user.password = LCString(password)
                        
                        _ = LCSMSClient.requestShortMessage(mobilePhoneNumber: "\(username)", templateName: "template_name", signatureName: "sign_name") { (result) in
                            switch result {
                            case .success:
                                isShowLoading = false
                                break
                            case .failure(error: let error):
                                
                                isShowLoading = false
                                print(error)
                            }
                        }
                        
                        _ = user.signUp { (result) in
                            
                            switch result {
                            case .success:
                                isShowLoading = false
                                successReason = "注册成功"
                                isLoginError = true
                                isLoginTrue = true
                                pageType = "signin"
                                print("注册成功")
                                break
                            case .failure(error: let error):
                                isShowLoading = false
                                errorReason = error.reason!;
                                isLoginError = true
                                isLoginTrue = false
                                 print("注册失败，失败原因：\(error)")
                                 
                            }
                        
                        }
                    }
                    
                    }
                if pageType == "signin"{
                    _ = LCUser.logIn(username: username, password: password) { result in
                        switch result {
                        case .success(object: let user):
                            isShowLoading = false
                            isFirstLogin = user.isFirstLogin as! LCBool
                            if(isFirstLogin == true){
                                isPressed1 = true
                            }else{
                                isLogin = true
                            }
                            objectId = user.objectId!
                            
                            print("1\(isPressed1)")
                            print("2\(isLogin)")
                            isLoginTrue = true
                        
                        case .failure(error: let error):
                            isShowLoading = false
                            errorReason = error.reason!;
                            isLoginError = true
                            isLoginTrue = false
                            
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
                Alert(title:Text( isLoginTrue ?"成功了":"出错了"),
                      message: Text(isLoginTrue ?"\(successReason)":"\(errorReason)"),
                    dismissButton: .default(Text("OK")))
                
            })
    

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
            .padding(.top,40)
        }
        .padding(.top,15)
    }
    
}
