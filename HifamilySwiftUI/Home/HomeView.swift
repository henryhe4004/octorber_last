//
//  HomeView.swift
//  HifamilySwiftUI
//
//  Created by 游 on 2021/9/14.
//

import SwiftUI
import CoreData
import LeanCloud


//首先通过扩展 UIApplication隐藏键盘
extension UIApplication{
    func endEditing(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct HomeView: View {
    //isHaveTree true 为创建者，false为加入者
    @State var isHaveTree = false
    @State var isPresented = false
    @State var isPersonPresented = false
    
    //家庭树的初始值
    var imgsTree = ["tree","second tree","third tree"]
    @State  private var indexTree = 0//默认树
    @State var familyIdWrite = 0
    @State var familyMemberCountWrite = 1
    @State var familyTreeWrite = 0
    @State var familyTreeName = ""
    @State var treeObjectId = ""
    
    //左边菜单栏
    @State var showLeftMenu = false
    @State var username = ""
    @State var status = 0
   
    
    @Binding var isLogin : Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
    
    var body: some View {
        
        let drag = DragGesture()
            .onEnded {
                    if $0.translation.width < -100 && status == 1{
                        withAnimation {
                                    self.showLeftMenu = false
                                }
                            }
                    else if $0.translation.width > 100 && status == 1{
                        withAnimation {
                                    self.showLeftMenu = true
                        }
                    }
            }
        return GeometryReader { geometry in
    
        ZStack(alignment: .leading) {
            VStack{
                //title
                Title(isPersonPresented: $isPersonPresented, showLeftMenu : $showLeftMenu,isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId, familyTreeName: $familyTreeName, status: $status)
                Divider()
                //title 下面部分
                TitleDown(familyTreeName: $familyTreeName, familyIdWrite: $familyIdWrite, familyMemberCountWrite: $familyMemberCountWrite,familyTreeWrite:$familyTreeWrite,isHaveTree :$isHaveTree,indexTree:$indexTree, treeObjectId: $treeObjectId, username: $username)
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .offset(x: self.showLeftMenu  ? 1 * geometry.size.width/2: 0)
            .disabled(self.showLeftMenu  ? true : false)
            .transition(.move(edge: .leading))
            
            
            if self.showLeftMenu{
                LeftMenuView()
                    .offset(y: 30)
                    .frame(width: 1 * geometry.size.width/2)
                    .transition(.move(edge: .leading))
            }
        }
        .gesture(drag)
        .onAppear(){
            let objectId = LCApplication.default.currentUser?.objectId
            self.objectId = objectId!
            let query = LCQuery(className: "_User")
            
            let _ = query.get(objectId!) { (result) in
                switch result {
                case .success(object: let todo):
                    let createrId = todo.id?.intValue
                    let status = todo.status?.intValue
                    self.status = status!
                    self.username = (todo.username?.stringValue)!
                    if(status == 1){
                        //创建者
                        isHaveTree = true
                        let familyTree = LCQuery(className: "familyTree")
                        familyTree.whereKey("createrId", .equalTo(createrId!))
                        _ = familyTree.find { result in
                            switch result {
                            case .success(objects: let tree):
                                for item in tree{
                                let treeName = item.familyName?.stringValue
                                let treeId = item.familyId?.intValue
                                let familyNum = item.familyNum?.intValue
                                self.familyMemberCountWrite = familyNum!
                                self.familyIdWrite = treeId!
                                self.treeObjectId = (item.objectId?.stringValue)!
                                familyTreeName = treeName!
                                    //更新
                                    do {
                                        let todo = LCObject(className: "_User", objectId: objectId!)
                                        try todo.set("familyTreeId", value: treeId)
                                        todo.save { (result) in
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
                    }else{
                        //加入者
                        isHaveTree = false
                        let treeId = todo.familyTreeId?.intValue
                        if(treeId == nil){
                            self.familyIdWrite = 0
                        }else{
                            self.familyIdWrite = treeId!
                            let familyTree = LCQuery(className: "familyTree")
                            familyTree.whereKey("familyId", .equalTo(treeId!))
                            _ = familyTree.find { result in
                                switch result {
                                case .success(objects: let tree):
                                    for item in tree{
                                    let treeName = item.familyName?.stringValue
                                    let familyNum = item.familyNum?.intValue
                                    self.familyMemberCountWrite = familyNum!
                                    self.treeObjectId = (item.objectId?.stringValue)!
                                    familyTreeName = treeName!
                                    }
                                    break
                                        
                                case .failure(error: let error):
                                    print(error)
                                }
                            }
                        }
                     
                        
                    }
                  

                case .failure(error: let error1):
                    print(error1)
                }
      
            }

    }
}

    struct TitleDown: View {
        @Binding var familyTreeName:String
        @Binding var familyIdWrite : Int
        @Binding var familyMemberCountWrite : Int
        @Binding var familyTreeWrite : Int
        @Binding var isHaveTree : Bool
        @Binding var indexTree : Int
        @Binding var treeObjectId : String
        @Binding var username : String
        var imgsTree = ["tree","second tree","third tree"]
        var body: some View {
            GeometryReader { geo in
            VStack {
                
                HStack() {
                    
                    Text("家庭ID：\(familyIdWrite)").font(.system(size: 14))
                    Spacer()
                    Text("总共成员:").font(.system(size: 14))
                        + Text("\(familyMemberCountWrite)").foregroundColor(Color("AccentColor"))
                        .font(.system(size: 16))
                    
                }.padding(EdgeInsets(top: 0, leading: 7, bottom: 10, trailing: 20))
                
                ZStack {
                    
                    HomeLandUIView()
                        .offset(x:-3)
                    HStack {
                        HStack {
                            Image(imgsTree[familyTreeWrite])
                                .animation(.interpolatingSpring(stiffness: 20, damping: 5))
                                .scaledToFit()
                                .offset(y: 20)
                        }
                        .frame(width: 300, height: 220, alignment: .center)
                        
                        //切换家庭树
                        Button(action: {
                            if indexTree == 2{
                                withAnimation{
                                    indexTree = 0
                                }
                                
                            }else{
                                withAnimation{
                                    indexTree = indexTree + 1
                                }
                                
                            }
                            familyTreeWrite = indexTree
                            if(treeObjectId != ""){
                            do {
                                let familyTree = LCObject(className: "familyTree", objectId: treeObjectId)
                                try familyTree.set("indexTree", value: familyTreeWrite)
                                familyTree.save { (result) in
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
                        }) {
                            VStack {
                                CutButton()
                            }
                            
                        }
                        .padding(EdgeInsets(top:280,leading:-80,bottom:0,trailing:0))
                        if(!isHaveTree){
                            AddFamilyButton(username: $username)
                        }
                        
                    }
                    .padding(EdgeInsets(top:0,leading:0,bottom:0,trailing:0))
                    
                    FamilyBlackboard(familyTreeName: $familyTreeName)
                    Textfield02()

                    
                }
            }
            .animation(.interpolatingSpring(stiffness: 20, damping: 5))
            }
        }
    }

//家庭树名字
//家庭树改名字在个人中心处改

    
struct FamilyBlackboard: View {
    //家庭树名字
    @Binding var familyTreeName:String
    @State var isPresented = false
    
        var body: some View {
            
            HStack {
                Text("\(familyTreeName)")
                .font(.system(size: 16))
                .foregroundColor(Color("FamliyTreeNameColor"))
                .frame(width: 90, height: 0)
                .offset(x: -123, y: 143)
                .multilineTextAlignment(.center)
              
            }
        }
    }
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//
//    }
//}
}


struct CutButton: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.triangle.2.circlepath")
                .foregroundColor(Color("AccentColor"))
                .frame(width: 23, height: 23, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text("切换")
                .fontWeight(.bold)
        }.padding(8)
        .background(Color.white)
        .cornerRadius(13)
        .shadow(color: Color("AccentColor"), radius: 3, x: 2, y: 2.0)
    }
}



struct AddFamilyButton: View {
    @State private var isPresented = false
    @State private var familyId = ""
    @State private var familyIDAlert = ""
    @State private var showingAlert = false
    @Binding var username : String
  
    var modalView: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                Text("输入想加入的家庭ID")
                    .font(.title3)
                    .foregroundColor(Color.gray)
                    .padding(.bottom,10)
                CustomTextField(text: $familyId,isFirstResponder: true)
                    .padding(.horizontal,20)
                    .padding(.top,8)
                    .padding(.bottom,8)
                    .background(Color("EventMarkersBackground"))
                           .cornerRadius(20)
                           .shadow(color: .gray, radius: 2)
                    .frame(width: 300, height: 45, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .font(/*@START_MENU_TOKEN@*/.title3/*@END_MENU_TOKEN@*/)
                
           
                Button(action: {
                        familyIDAlert = familyId
                        self.showingAlert = true
                    //发送申请，查看是否有这个家庭树ID
                    if(familyId != ""){
                        let query = LCQuery(className: "familyTree")
                        query.whereKey("familyId", .equalTo(Int(familyId)!))
                        _ = query.find { result in
                            switch result {
                            case .success(objects: _):
                                let InvitationUser = LCObject(className: "InvitationUser")
                                InvitationUser.treeId = Int(familyIDAlert)
                                InvitationUser.userId = LCApplication.default.currentUser?.id
                                InvitationUser.username = username
                                
                                _ =  InvitationUser.save { result in
                                      switch result {
                                      case .success:
                                          // 成功保存之后，执行其他逻辑
                                          break
                                      case .failure(error: let error):
                                          // 异常处理
                                          print(error)
                                      }
                                  }
                                print("right")
                                break
                            case .failure(error: let error):
                                familyIDAlert = ""
                                print(error)
                            }
                        }
                    }
                    
                    familyId = ""
                }) {
                    Text("发送申请")
                }
                .background(Color("AccentColor"))
                .frame(width:UIScreen.main.bounds.width/2 - 80,height:40)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(30)
                .alert(isPresented:$showingAlert) {
                    familyIDAlert != "" ? Alert(title: Text("发送申请成功"), message: Text("已向\(familyIDAlert)家庭发送申请")) : Alert(title: Text("发送申请失败"), message: Text("请输入正确的家庭ID"))
                        }
                .padding(.top,20)
                
                Spacer()
            }
            .padding(.top,45)
            .frame(width: geo.size.width, height: geo.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                        print("收回键盘")
                        UIApplication.shared.endEditing()
        }
            }
        }
        
    }
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            VStack {
                HStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(Color("AccentColor"))
                        .frame(width: 23, height: 23, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("加入")
                        .fontWeight(.bold)
                }.padding(8)
                .background(Color.white)
                .cornerRadius(13)
                .shadow(color: Color("AccentColor"), radius: 3, x: 2, y: 2.0)
            }
        }
        .padding(EdgeInsets(top:400,leading:-70,bottom:0,trailing:0))
        .sheet(isPresented: $isPresented, content: {
                    self.modalView
                })
        
    }
}

//让textfield 成为第一响应者，即进入就聚焦
struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }

    }

    @Binding var text: String
    var isFirstResponder: Bool = false

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}

struct Title: View {
    @Binding var isPersonPresented: Bool
    @Binding var showLeftMenu : Bool
    
    @Binding var isLogin : Bool
    @Binding var isFirstLogin : LCBool
    @Binding var isPressed1 : Bool
    @Binding var objectId:LCString
    @Binding var familyTreeName:String
    @Binding var status : Int
    
    
    
    var body: some View {
        HStack {
            Image("three line")
                .resizable()
                .frame(width:23,
                       height:23,
                       alignment:.center)
            
                .onTapGesture {
                    if(status == 1){
                        withAnimation {
                        self.showLeftMenu  = true
                        }
                    }
                    
                }
            Spacer()
            Text("Your family tree")
                .foregroundColor(Color("AccentColor"))
            
            Spacer()
            Button(action: {
                    self.isPersonPresented = true
                
            }) {
                Image("person")
            }
            .fullScreenCover(isPresented: $isPersonPresented, content: {
                InformUIView(isLogin: $isLogin,isFirstLogin: $isFirstLogin,isPressed1: $isPressed1,objectId: $objectId, treeName: $familyTreeName)
            })
            
        }.padding(15)
        
    }
}

}
